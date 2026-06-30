import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors_x.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';
import '../sos/sos_contacts_screen.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with TickerProviderStateMixin {
  static const _holdMs = 3000;
  bool _pressing = false;
  double _progress = 0.0;
  Timer? _holdTimer;
  DateTime? _pressStart;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _rotCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _rotCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = context.read<AuthProvider>().user?.uid;
      if (uid != null) context.read<SosProvider>().loadContacts(uid);
    });
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _pulseCtrl.dispose();
    _rotCtrl.dispose();
    super.dispose();
  }

  void _onPressStart() {
    final sos = context.read<SosProvider>();
    if (sos.active) { _cancelSos(); return; }
    setState(() { _pressing = true; _progress = 0.0; });
    _pressStart = DateTime.now();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) { t.cancel(); return; }
      final elapsed = DateTime.now().difference(_pressStart!).inMilliseconds;
      final p = (elapsed / _holdMs).clamp(0.0, 1.0);
      setState(() => _progress = p);
      if (p >= 1.0) { t.cancel(); _activateSos(); }
    });
  }

  void _onPressEnd() {
    if (context.read<SosProvider>().active) return;
    _holdTimer?.cancel();
    setState(() { _pressing = false; _progress = 0.0; });
  }

  Future<void> _activateSos() async {
    setState(() { _pressing = false; _progress = 0.0; });
    final user = context.read<AuthProvider>().user;
    final sos = context.read<SosProvider>();

    if (sos.contacts.isEmpty) {
      final goConfig = await _confirmNoContacts();
      if (goConfig == true) {
        if (mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SosContactsScreen()));
        }
        return;
      }
    }

    await sos.activateSos(
      userId:    user?.uid   ?? 'anonymous',
      userName:  user?.fullName ?? '',
      userPhone: user?.phone  ?? '',
    );
    _vibrateEmergency();

    if (!mounted) return;
    final t = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.sosActivated),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 3),
      ),
    );

    await _waitForSendAndShowSummary();
  }

  Future<bool?> _confirmNoContacts() {
    final t = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.colors.cardBg,
        title: Text(t.sosNoContactsTitle, style: TextStyle(color: context.colors.textPrimary, fontSize: 16)),
        content: Text(t.sosNoContactsBody, style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.sosContinueAnyway, style: TextStyle(color: context.colors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.sosAddContacts, style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Future<void> _waitForSendAndShowSummary() async {
    final sos = context.read<SosProvider>();
    var guard = 0;
    while (sos.sendingMessages && guard < 40) {
      await Future.delayed(const Duration(milliseconds: 250));
      guard++;
    }
    if (!mounted) return;
    final t = AppLocalizations.of(context)!;
    final results = sos.lastSendResults;
    if (results.isEmpty) return;

    final sent = results.where((r) => r.success).length;
    final total = results.length;
    final message = sent == total
        ? t.sosSentToAll(sent.toString(), sent == 1 ? '' : 's')
        : t.sosSentPartial(sent.toString(), total.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: sent == total ? AppColors.success : AppColors.warn,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _cancelSos() async {
    await context.read<SosProvider>().cancelSos();
    _pulseCtrl.stop();
    _pulseCtrl.value = 0;
    _pulseCtrl.repeat(reverse: true);
    if (mounted) {
      final t = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.sosCancelled), backgroundColor: AppColors.success),
      );
    }
  }

  Future<void> _vibrateEmergency() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(
        pattern: [0,200,100,200,100,200,100,500,100,500,100,500,100,200,100,200,100,200],
        intensities: [0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255],
      );
    }
  }

  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:911');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final sos = context.watch<SosProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(t.sosTitle,
                  style: TextStyle(color: context.colors.textPrimary,
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                sos.active ? t.sosTapToCancel : t.sosHoldInstruction,
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 24),
              _buildSosButton(sos.active),
              const SizedBox(height: 6),
              if (!sos.active)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 4,
                      backgroundColor: context.colors.borderColor,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
              if (sos.sendingMessages)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 12, height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.warn)),
                      const SizedBox(width: 8),
                      Text(t.sosSendingMessages, style: const TextStyle(color: AppColors.warn, fontSize: 11)),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _InfoCard(label: t.sosLocation, value: '📍', sublabel: t.sosGpsActive),
                  const SizedBox(width: 8),
                  _InfoCard(label: 'GPS', value: t.sosGpsOn,
                      valueColor: AppColors.success, sublabel: t.sosOnline),
                  const SizedBox(width: 8),
                  _InfoCard(label: t.sosContacts, value: '${sos.contacts.length}', sublabel: 'SOS'),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.sosInfoBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.22)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.sosInfoTitle,
                        style: const TextStyle(color: AppColors.secondary,
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    ...[
                      t.sosInfoLocation,
                      t.sosInfoNotify,
                      t.sosInfoVibration,
                      t.sosInfoReport,
                    ].map((txt) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check, color: AppColors.success, size: 14),
                          const SizedBox(width: 8),
                          Text(txt, style: TextStyle(color: context.colors.textSecondary, fontSize: 10)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                sos.active ? t.sosStatusActive : t.sosStatusInactive,
                style: TextStyle(
                  color: sos.active ? AppColors.primary : context.colors.textSecondary,
                  fontSize: 14,
                  fontWeight: sos.active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.phone, size: 16),
                      label: Text(t.sosCall911),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 0.5),
                        minimumSize: const Size(0, 44),
                      ),
                      onPressed: _callEmergency,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.contacts, size: 16),
                      label: Text(t.sosManageContacts),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.textSecondary,
                        side: BorderSide(color: context.colors.borderColor, width: 0.5),
                        minimumSize: const Size(0, 44),
                      ),
                      onPressed: () async {
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const SosContactsScreen()));
                        final uid = context.read<AuthProvider>().user?.uid;
                        if (uid != null && mounted) {
                          context.read<SosProvider>().loadContacts(uid);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSosButton(bool active) {
    return GestureDetector(
      onTapDown: (_) => _onPressStart(),
      onTapUp:   (_) => _onPressEnd(),
      onTapCancel:   _onPressEnd,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnim, _rotCtrl]),
        builder: (_, __) {
          return SizedBox(
            width: 200, height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: _rotCtrl.value * 2 * math.pi,
                  child: Container(
                    width: 196, height: 196,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: active
                            ? AppColors.primary.withOpacity(0.5)
                            : AppColors.primary.withOpacity(0.18),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 172, height: 172,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: active
                          ? AppColors.primary.withOpacity(0.6)
                          : AppColors.primary.withOpacity(0.25),
                      width: 2,
                    ),
                    boxShadow: active
                        ? [BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 24, spreadRadius: 4)]
                        : null,
                  ),
                ),
                Transform.scale(
                  scale: active ? _pulseAnim.value : (_pressing ? 0.93 : 1.0),
                  child: Container(
                    width: 136, height: 136,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: active
                            ? [AppColors.primary, AppColors.secondary]
                            : [const Color(0xFFB71C1C), AppColors.primary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(active ? 0.6 : 0.4),
                          blurRadius: active ? 32 : 20,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SOS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              shadows: active ? [const Shadow(color: Colors.white24, blurRadius: 8)] : null,
                            )),
                        Text(
                          active ? 'ACTIVO' : 'EMERGENCIA',
                          style: const TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_pressing && !active)
                  CustomPaint(
                    size: const Size(172, 172),
                    painter: _ArcPainter(_progress),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  const _ArcPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) => old.progress != progress;
}

class _InfoCard extends StatelessWidget {
  final String label, value;
  final String? sublabel;
  final Color? valueColor;
  const _InfoCard({required this.label, required this.value, this.sublabel, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.colors.borderColor, width: 0.5),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: valueColor ?? context.colors.textPrimary,
                    fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: context.colors.textSecondary, fontSize: 9)),
            if (sublabel != null)
              Text(sublabel!, style: TextStyle(color: context.colors.textSecondary, fontSize: 8)),
          ],
        ),
      ),
    );
  }
}

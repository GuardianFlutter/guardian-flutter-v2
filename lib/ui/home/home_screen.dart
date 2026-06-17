import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/models.dart';
import '../../providers/providers.dart';
import '../report/report_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth    = context.watch<AuthProvider>();
    final reports = context.watch<ReportProvider>();
    final firstName = auth.user?.fullName.split(' ').firstOrNull ?? 'Usuario';

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => context.read<ReportProvider>().loadReports(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 52, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bienvenido/a 👋',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              Text('Hola, $firstName',
                                  style: const TextStyle(color: AppColors.textPrimary,
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.borderColor, width: 0.5),
                              ),
                              child: const Icon(Icons.notifications_outlined,
                                  color: AppColors.textSecondary, size: 18),
                            ),
                            Positioned(
                              right: 0, top: 0,
                              child: Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.bgDark, width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Alert Banner
                    _AlertBanner(),
                    const SizedBox(height: 12),
                    // Filter pills
                    _FilterPills(),
                    const SizedBox(height: 12),
                    const Text('Incidentes recientes',
                        style: TextStyle(color: AppColors.textPrimary,
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // List
            if (reports.loading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ),
              )
            else if (reports.reports.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text('No hay reportes aún.\nSé el primero en reportar.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final report = reports.reports[i];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, i == reports.reports.length - 1 ? 24 : 0),
                      child: ReportCard(
                        report: report,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ReportDetailScreen(reportId: report.id))),
                      ),
                    );
                  },
                  childCount: reports.reports.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Alert Banner ──────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.alertBannerBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('⚠ Alerta en tu zona',
              style: TextStyle(color: AppColors.secondary, fontSize: 11)),
          const SizedBox(height: 4),
          const Text('Robo reportado a 200m',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          const Text('Av. Rivadavia 4502 · hace 5 min',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}

// ── Filter Pills ──────────────────────────────────────────────
class _FilterPills extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Pill(label: 'Robos', active: true),
          const SizedBox(width: 6),
          _Pill(label: 'Accidentes'),
          const SizedBox(width: 6),
          _Pill(label: 'Zonas'),
          const SizedBox(width: 6),
          _Pill(label: '+ más'),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool active;
  const _Pill({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: active ? AppColors.catSelectedBg : AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.borderColor,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? AppColors.primary : AppColors.textSecondary,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ── Report Card ───────────────────────────────────────────────
class ReportCard extends StatelessWidget {
  final ReportModel report;
  final VoidCallback? onTap;

  const ReportCard({super.key, required this.report, this.onTap});

  Color _dotColor() {
    switch (report.type) {
      case 'ROBO':
      case 'ASALTO':      return AppColors.primary;
      case 'ACCIDENTE':   return AppColors.warn;
      case 'INCENDIO':    return AppColors.secondary;
      case 'ZONA_PELIGROSA': return AppColors.error;
      default:            return AppColors.textSecondary;
    }
  }

  Color _statusColor() {
    switch (report.status) {
      case 'PENDIENTE':  return AppColors.warn;
      case 'VERIFICADO': return AppColors.secondary;
      case 'RESUELTO':   return AppColors.success;
      default:           return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(report.createdAt.toDate());
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.fromLTRB(16, 11, 13, 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(color: _dotColor(), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(report.reportType.displayName.toUpperCase(),
                        style: const TextStyle(color: AppColors.textSecondary,
                            fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warn.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(report.status,
                        style: TextStyle(color: _statusColor(),
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(report.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textPrimary,
                      fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(report.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 9),
              const Divider(height: 1, color: AppColors.borderColor),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.primary, size: 12),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(report.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  ),
                  Text(dateStr, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.person_pin, color: AppColors.borderColor, size: 12),
                  const SizedBox(width: 4),
                  Text(report.userName,
                      style: const TextStyle(color: AppColors.borderColor, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

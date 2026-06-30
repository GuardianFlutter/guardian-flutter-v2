import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors_x.dart';
import '../../data/models/models.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';
import '../report/report_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _activeFilter;

  // Las keys internas (ROBO, ASALTO, etc.) no se traducen — son
  // identificadores de datos. Lo que se traduce es la etiqueta visible
  // de cada pill, que se resuelve en build() con AppLocalizations.
  static const _filterGroups = <String, List<String>>{
    'robos': ['ROBO', 'ASALTO'],
    'accidentes': ['ACCIDENTE', 'INCENDIO'],
    'zonas': ['ZONA_PELIGROSA', 'CALLE_OSCURA'],
    'otros': ['SOSPECHOSO', 'VANDALISMO', 'OTRO'],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().loadReports();
    });
  }

  List<ReportModel> _applyFilter(List<ReportModel> all) {
    if (_activeFilter == null) return all;
    final types = _filterGroups[_activeFilter] ?? [];
    return all.where((r) => types.contains(r.type)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final auth    = context.watch<AuthProvider>();
    final reports = context.watch<ReportProvider>();
    final firstName = auth.user?.fullName.split(' ').firstOrNull ?? 'Usuario';
    final filtered = _applyFilter(reports.reports);

    final filterLabels = <String, String>{
      'robos': t.homeFilterRobos,
      'accidentes': t.homeFilterAccidentes,
      'zonas': t.homeFilterZonas,
      'otros': t.homeFilterOtros,
    };

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
                              Text(t.homeWelcome,
                                  style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                              Text(t.homeGreeting(firstName),
                                  style: TextStyle(color: context.colors.textPrimary,
                                      fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        _NotificationBell(hasRecentReport: reports.mostRecentReport != null),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (reports.mostRecentReport != null)
                      _AlertBanner(report: reports.mostRecentReport!),
                    if (reports.mostRecentReport != null)
                      const SizedBox(height: 12),
                    _FilterPills(
                      activeFilter: _activeFilter,
                      labels: filterLabels,
                      onSelect: (key) {
                        setState(() {
                          _activeFilter = (_activeFilter == key) ? null : key;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(t.homeRecentIncidents,
                            style: TextStyle(color: context.colors.textPrimary,
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        if (_activeFilter != null)
                          GestureDetector(
                            onTap: () => setState(() => _activeFilter = null),
                            child: Text(t.homeClearFilter,
                                style: const TextStyle(color: AppColors.primary, fontSize: 11)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            if (reports.loading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                ),
              )
            else if (filtered.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      _activeFilter != null ? t.homeNoReportsFiltered : t.homeNoReports,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final report = filtered[i];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, i == filtered.length - 1 ? 24 : 0),
                      child: ReportCard(
                        report: report,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ReportDetailScreen(reportId: report.id))),
                      ),
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Notification bell ──────────────────────────────────────────
class _NotificationBell extends StatelessWidget {
  final bool hasRecentReport;
  const _NotificationBell({required this.hasRecentReport});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.homeNotificationHint), backgroundColor: context.colors.cardBg),
        );
      },
      child: Stack(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: context.colors.cardBg,
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.borderColor, width: 0.5),
            ),
            child: Icon(Icons.notifications_outlined, color: context.colors.textSecondary, size: 18),
          ),
          if (hasRecentReport)
            Positioned(
              right: 0, top: 0,
              child: Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.bg, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Alert Banner ──────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  final ReportModel report;
  const _AlertBanner({required this.report});

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'recién';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours}h';
    return 'hace ${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ReportDetailScreen(reportId: report.id))),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.alertBannerBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.homeLastIncident, style: const TextStyle(color: AppColors.secondary, fontSize: 11)),
            const SizedBox(height: 4),
            Text(report.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(
              '${report.address.isNotEmpty ? report.address : "Ubicación no especificada"} · ${_timeAgo(report.createdAt.toDate())}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter Pills ──────────────────────────────────────────────
class _FilterPills extends StatelessWidget {
  final String? activeFilter;
  final Map<String, String> labels; // key -> texto traducido
  final ValueChanged<String> onSelect;

  const _FilterPills({
    required this.activeFilter,
    required this.labels,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in labels.entries) ...[
            _Pill(
              label: entry.value,
              active: activeFilter == entry.key,
              onTap: () => onSelect(entry.key),
            ),
            const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Pill({required this.label, required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.catSelectedBg : context.colors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : context.colors.borderColor,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.primary : context.colors.textSecondary,
            fontSize: 10,
          ),
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
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.borderColor, width: 0.5),
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
                        style: TextStyle(color: context.colors.textSecondary,
                            fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warn.withOpacity(0.1),
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
                  style: TextStyle(color: context.colors.textPrimary,
                      fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(report.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
              const SizedBox(height: 9),
              Divider(height: 1, color: context.colors.borderColor),
              const SizedBox(height: 7),
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.primary, size: 12),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(report.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
                  ),
                  Text(dateStr, style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(Icons.person_pin, color: context.colors.borderColor, size: 12),
                  const SizedBox(width: 4),
                  Text(report.userName,
                      style: TextStyle(color: context.colors.borderColor, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

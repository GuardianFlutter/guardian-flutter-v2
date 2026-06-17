import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../providers/providers.dart';
import '../report/report_detail_screen.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  List<ReportModel> _reports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = context.read<AuthProvider>().user?.uid;
    if (uid == null) { setState(() => _loading = false); return; }
    setState(() => _loading = true);
    final repo = ReportRepository();
    _reports = await repo.getReportsByUser(uid);
    setState(() => _loading = false);
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'VERIFICADO': return AppColors.secondary;
      case 'RESUELTO':   return AppColors.success;
      default:           return AppColors.warn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis reportes')),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _reports.isEmpty
              ? const Center(
                  child: Text('No has enviado reportes aún',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _reports.length,
                  itemBuilder: (_, i) {
                    final r = _reports[i];
                    final date = DateFormat('dd/MM/yyyy').format(r.createdAt.toDate());
                    return GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ReportDetailScreen(reportId: r.id))),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderColor, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                  color: AppColors.primary, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.title,
                                      style: const TextStyle(color: AppColors.textPrimary,
                                          fontSize: 14, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 2),
                                  Text(date,
                                      style: const TextStyle(color: AppColors.textSecondary,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: _statusColor(r.status).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(r.status,
                                  style: TextStyle(color: _statusColor(r.status),
                                      fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.chevron_right, color: AppColors.borderColor, size: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

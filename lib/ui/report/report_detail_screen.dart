import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';

class ReportDetailScreen extends StatefulWidget {
  final String reportId;
  const ReportDetailScreen({super.key, required this.reportId});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  ReportModel? _report;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = ReportRepository();
      final r = await repo.getReportById(widget.reportId);
      setState(() { _report = r; _loading = false; });
    } catch (_) {
      setState(() => _loading = false);
    }
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
      appBar: AppBar(
        title: const Text('Detalle del reporte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _report == null
              ? const Center(child: Text('Reporte no encontrado',
                    style: TextStyle(color: AppColors.textSecondary)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildContent(_report!),
                ),
    );
  }

  Widget _buildContent(ReportModel r) {
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(r.createdAt.toDate());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photo
        if (r.photoUrls.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(r.photoUrls.first,
                width: double.infinity, height: 200, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox()),
          ),
        const SizedBox(height: 14),
        // Type badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.catSelectedBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(r.reportType.displayName.toUpperCase(),
              style: const TextStyle(color: AppColors.primary,
                  fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        // Title
        Text(r.title,
            style: const TextStyle(color: AppColors.textPrimary,
                fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        // Status
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _statusColor(r.status).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _statusColor(r.status).withValues(alpha: 0.4)),
              ),
              child: Text(r.status,
                  style: TextStyle(color: _statusColor(r.status),
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Description
        Text(r.description,
            style: const TextStyle(color: AppColors.textSecondary,
                fontSize: 14, height: 1.6)),
        const SizedBox(height: 16),
        const Divider(color: AppColors.borderColor),
        const SizedBox(height: 12),
        // Meta info
        _MetaRow(icon: Icons.location_on, label: r.address.isNotEmpty ? r.address : 'Sin ubicación'),
        const SizedBox(height: 8),
        _MetaRow(icon: Icons.calendar_today, label: dateStr),
        const SizedBox(height: 8),
        _MetaRow(icon: Icons.person, label: r.userName.isNotEmpty ? r.userName : 'Anónimo'),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
      ],
    );
  }
}

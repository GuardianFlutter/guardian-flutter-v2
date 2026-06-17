// ═══════════════════════════════════════════════════════════════
// REPORT SCREEN
// ═══════════════════════════════════════════════════════════════
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../providers/providers.dart';
import '../auth/splash_screen.dart' show GradientButton;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _formKey   = GlobalKey<FormState>();

  ReportType _selectedType = ReportType.ROBO;
  File? _imageFile;
  double _lat = 0, _lon = 0;
  String _address = 'Detectando tu ubicación...';
  bool _loadingLocation = false;
  bool _submitting = false;

  final _photoRepo = PhotoRepository();

  final _categories = [
    (ReportType.ROBO,          '🏍️', 'Robo moto'),
    (ReportType.ACCIDENTE,     '🚗', 'Accidente'),
    (ReportType.ASALTO,        '😨', 'Violencia'),
    (ReportType.CALLE_OSCURA,  '🌑', 'Calle oscura'),
    (ReportType.ZONA_PELIGROSA,'⛔', 'Zona peligrosa'),
    (ReportType.OTRO,          '📢', 'Otro'),
  ];

  @override
  void initState() {
    super.initState();
    _detectLocation();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    setState(() { _loadingLocation = true; _address = 'Detectando ubicación...'; });
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        setState(() { _address = 'Permiso denegado'; _loadingLocation = false; });
        return;
      }
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _lat = pos.latitude; _lon = pos.longitude;
      try {
        final placemarks = await placemarkFromCoordinates(_lat, _lon);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [p.street, p.locality].where((s) => s != null && s.isNotEmpty).toList();
          _address = parts.join(', ');
        }
      } catch (_) {
        _address = '$_lat, $_lon';
      }
    } catch (e) {
      _address = 'No se pudo detectar';
    } finally {
      setState(() => _loadingLocation = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debés iniciar sesión'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final photoUrls = <String>[];
      if (_imageFile != null) {
        final url = await _photoRepo.uploadPhoto(_imageFile!);
        photoUrls.add(url);
      }

      final report = ReportModel(
        userId: user.uid,
        userName: user.fullName.isNotEmpty ? user.fullName : user.email,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        type: _selectedType.name,
        latitude: _lat,
        longitude: _lon,
        address: _address,
        photoUrls: photoUrls,
        createdAt: Timestamp.now(),
      );

      final repo = ReportRepository();
      await repo.createReport(report);
      await context.read<ReportProvider>().loadReports();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte enviado exitosamente'),
              backgroundColor: AppColors.success),
        );
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      setState(() => _submitting = false);
    }
  }

  void _clearForm() {
    _titleCtrl.clear();
    _descCtrl.clear();
    setState(() {
      _imageFile = null;
      _selectedType = ReportType.ROBO;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text('Nuevo Reporte',
                    style: TextStyle(color: AppColors.textPrimary,
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                // Category label
                const Text('Categoría del incidente',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                const SizedBox(height: 8),
                // Category grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  children: _categories.map((cat) {
                    final (type, icon, name) = cat;
                    final selected = _selectedType == type;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.catSelectedBg : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.borderColor,
                            width: selected ? 1 : 0.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(icon, style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 3),
                            Text(name,
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                // Title
                TextFormField(
                  controller: _titleCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Título del incidente'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresá un título' : null,
                ),
                const SizedBox(height: 10),
                // Description
                const Text('Descripción',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Describí lo que ocurrió…'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresá una descripción' : null,
                ),
                const SizedBox(height: 10),
                // Location
                const Text('Ubicación',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderColor, width: 0.5),
                        ),
                        child: _loadingLocation
                            ? const SizedBox(
                                height: 16, width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                            : Text(_address,
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                maxLines: 2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                      ),
                      onPressed: _detectLocation,
                      child: const Text('GPS', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Photo
                if (_imageFile == null)
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1,
                          style: BorderStyle.none, // dashed not supported natively
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: AppColors.textSecondary, size: 20),
                          SizedBox(width: 8),
                          Text('Agregar foto',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ),
                  )
                else
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_imageFile!,
                            width: double.infinity, height: 160, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => _imageFile = null),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54, shape: BoxShape.circle),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 14),
                GradientButton(
                  label: 'Enviar reporte',
                  loading: _submitting,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

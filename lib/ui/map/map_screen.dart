import 'dart:async' as _async;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors_x.dart';
import '../../data/models/models.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  // Default: Berazategui, Buenos Aires
  static const _defaultCenter = LatLng(-34.7644, -58.2089);
  static const _proximityM = 300.0;

  LatLng? _userLocation;
  bool _locationLoading = false;
  final Set<String> _alertedIds = {};
  _async.StreamSubscription<Position>? _positionSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().loadReports();
      _startLocation();
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  Future<void> _startLocation() async {
    setState(() => _locationLoading = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) {
        setState(() => _locationLoading = false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final gp  = LatLng(pos.latitude, pos.longitude);
      if (mounted) {
        setState(() { _userLocation = gp; _locationLoading = false; });
        _mapController.move(gp, 16);
      }
      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 20),
      ).listen((p) {
        if (mounted) {
          final newGp = LatLng(p.latitude, p.longitude);
          setState(() => _userLocation = newGp);
          _checkProximity(newGp);
        }
      });
    } catch (_) {
      setState(() => _locationLoading = false);
    }
  }

  void _checkProximity(LatLng userGp) {
    final t = AppLocalizations.of(context)!;
    final reports = context.read<ReportProvider>().reports;
    for (final r in reports) {
      if (r.latitude == 0 && r.longitude == 0) continue;
      final dist = _haversineM(userGp, LatLng(r.latitude, r.longitude));
      if (dist <= _proximityM && !_alertedIds.contains(r.id)) {
        _alertedIds.add(r.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.mapProximityAlert(r.title, dist.toInt().toString())),
              backgroundColor: AppColors.primary,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  double _haversineM(LatLng a, LatLng b) {
    const r = 6371000.0;
    final dLat = _rad(b.latitude - a.latitude);
    final dLon = _rad(b.longitude - a.longitude);
    final s = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_rad(a.latitude)) * math.cos(_rad(b.latitude)) * math.pow(math.sin(dLon / 2), 2);
    return r * 2 * math.atan2(math.sqrt(s), math.sqrt(1 - s));
  }

  double _rad(double d) => d * math.pi / 180;

  Color _markerColor(String type) {
    switch (type) {
      case 'ROBO':
      case 'ASALTO': return AppColors.primary;
      case 'ACCIDENTE':
      case 'ZONA_PELIGROSA': return AppColors.warn;
      default: return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final reports = context.watch<ReportProvider>().reports;
    final user = context.watch<AuthProvider>().user;

    // Build markers
    final markers = <Marker>[];
    for (final r in reports) {
      if (r.latitude == 0 && r.longitude == 0) continue;
      markers.add(
        Marker(
          point: LatLng(r.latitude, r.longitude),
          width: 36, height: 36,
          child: GestureDetector(
            onTap: () => _showReportCard(r),
            child: _PinWidget(color: _markerColor(r.type)),
          ),
        ),
      );
    }
    // User location marker — ahora muestra su foto de perfil si tiene una
    if (_userLocation != null) {
      markers.add(
        Marker(
          point: _userLocation!,
          width: 40, height: 40,
          child: _UserLocationMarker(
            photoUrl: user?.photoUrl,
            initials: user?.getInitials() ?? '',
          ),
        ),
      );
    }

    // 2 nearest reports for cards
    List<ReportModel> nearestReports = [];
    if (_userLocation != null && reports.isNotEmpty) {
      nearestReports = [...reports]
        ..sort((a, b) => _haversineM(_userLocation!, LatLng(a.latitude, a.longitude))
            .compareTo(_haversineM(_userLocation!, LatLng(b.latitude, b.longitude))));
      nearestReports = nearestReports.take(2).toList();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _defaultCenter,
              initialZoom: 15,
              minZoom: 10,
              maxZoom: 19,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.catedra.guardian',
              ),
              MarkerLayer(markers: markers),
            ],
          ),
          // Header overlay
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              color: context.colors.bg.withOpacity(0.92),
              padding: const EdgeInsets.fromLTRB(16, 52, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(t.mapTitle,
                        style: TextStyle(color: context.colors.textPrimary,
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    width: 7, height: 7,
                    decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text(t.mapRealtime, style: const TextStyle(color: AppColors.success, fontSize: 12)),
                ],
              ),
            ),
          ),
          // Bottom cards
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              color: context.colors.bg.withOpacity(0.95),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LegendDot(color: AppColors.primary, label: t.mapLegendRobo),
                      const SizedBox(width: 16),
                      _LegendDot(color: AppColors.secondary, label: t.mapLegendViolencia),
                      const SizedBox(width: 16),
                      _LegendDot(color: AppColors.warn, label: t.mapLegendZona),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...nearestReports.map((r) {
                    final dist = _userLocation != null
                        ? _haversineM(_userLocation!, LatLng(r.latitude, r.longitude)).toInt()
                        : null;
                    return _IncidentCard(report: r, distanceM: dist);
                  }),
                ],
              ),
            ),
          ),
          // GPS button
          Positioned(
            right: 16,
            bottom: nearestReports.isEmpty ? 80 : 160,
            child: FloatingActionButton.small(
              backgroundColor: context.colors.cardBg,
              onPressed: () {
                if (_userLocation != null) {
                  _mapController.move(_userLocation!, 16);
                } else {
                  _startLocation();
                }
              },
              child: _locationLoading
                  ? const SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                  : const Icon(Icons.my_location, color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportCard(ReportModel report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.cardBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(report.reportType.displayName.toUpperCase(),
                style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(report.title,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(report.description,
                style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.primary, size: 14),
                const SizedBox(width: 4),
                Expanded(child: Text(report.address,
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 12))),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── User location marker (con foto de perfil) ──────────────────
class _UserLocationMarker extends StatelessWidget {
  final String? photoUrl;
  final String initials;
  const _UserLocationMarker({this.photoUrl, required this.initials});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hasPhoto ? null : AppColors.success,
        gradient: hasPhoto ? const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ) : null,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [BoxShadow(color: AppColors.success.withOpacity(0.5), blurRadius: 8)],
      ),
      child: hasPhoto
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                width: 40, height: 40,
                placeholder: (_, __) => const Center(
                  child: SizedBox(width: 14, height: 14,
                      child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.white)),
                ),
                errorWidget: (_, __, ___) => Center(
                  child: Text(initials,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          : Center(
              child: initials.isNotEmpty
                  ? Text(initials, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))
                  : const Icon(Icons.person, color: Colors.white, size: 18),
            ),
    );
  }
}

class _PinWidget extends StatelessWidget {
  final Color color;
  const _PinWidget({required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)],
          ),
          child: const Icon(Icons.circle, size: 8, color: Colors.white),
        ),
        CustomPaint(
          size: const Size(8, 6),
          painter: _TrianglePainter(color),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
      ],
    );
  }
}

class _IncidentCard extends StatelessWidget {
  final ReportModel report;
  final int? distanceM;
  const _IncidentCard({required this.report, this.distanceM});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.borderColor, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 9, height: 9,
            decoration: BoxDecoration(
              color: report.type == 'ROBO' || report.type == 'ASALTO'
                  ? AppColors.primary : AppColors.warn,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.title,
                    style: TextStyle(color: context.colors.textPrimary,
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                  distanceM != null
                      ? 'A ${distanceM}m · ${report.address.length > 25 ? report.address.substring(0, 25) : report.address}'
                      : report.address,
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            distanceM != null && distanceM! < 300 ? t.mapActive : t.mapOngoing,
            style: TextStyle(
              color: distanceM != null && distanceM! < 300 ? AppColors.primary : AppColors.warn,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

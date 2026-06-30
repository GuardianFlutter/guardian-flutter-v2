import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

/// Claves usadas en SharedPreferences. Otras pantallas (por ejemplo,
/// el listener de proximidad en MapScreen) pueden leer estas mismas
/// claves para decidir si deben mostrar o no una notificación/snackbar.
class NotificationPrefs {
  static const keyNearbyAlerts   = 'notif_nearby_alerts';
  static const keyNewReports     = 'notif_new_reports';
  static const keySosFromContacts = 'notif_sos_contacts';
  static const keySound          = 'notif_sound';
  static const keyRadiusKm       = 'notif_radius_km';

  static Future<bool> getBool(String key, {bool defaultValue = true}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<double> getRadius() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keyRadiusKm) ?? 1.0;
  }
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _loading = true;
  bool _nearbyAlerts = true;
  bool _newReports = true;
  bool _sosFromContacts = true;
  bool _sound = true;
  double _radiusKm = 1.0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nearbyAlerts     = prefs.getBool(NotificationPrefs.keyNearbyAlerts) ?? true;
      _newReports       = prefs.getBool(NotificationPrefs.keyNewReports) ?? true;
      _sosFromContacts  = prefs.getBool(NotificationPrefs.keySosFromContacts) ?? true;
      _sound            = prefs.getBool(NotificationPrefs.keySound) ?? true;
      _radiusKm         = prefs.getDouble(NotificationPrefs.keyRadiusKm) ?? 1.0;
      _loading = false;
    });
  }

  Future<void> _setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _setRadius(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(NotificationPrefs.keyRadiusKm, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SectionLabel('Alertas de incidentes'),
                _SwitchRow(
                  icon: Icons.location_on_outlined,
                  title: 'Alertas cercanas',
                  subtitle: 'Avisar cuando hay un incidente cerca de tu ubicación',
                  value: _nearbyAlerts,
                  onChanged: (v) {
                    setState(() => _nearbyAlerts = v);
                    _setBool(NotificationPrefs.keyNearbyAlerts, v);
                  },
                ),
                if (_nearbyAlerts) _RadiusSlider(
                  value: _radiusKm,
                  onChanged: (v) {
                    setState(() => _radiusKm = v);
                    _setRadius(v);
                  },
                ),
                _SwitchRow(
                  icon: Icons.description_outlined,
                  title: 'Nuevos reportes',
                  subtitle: 'Avisar cuando se publica un reporte nuevo en tu zona',
                  value: _newReports,
                  onChanged: (v) {
                    setState(() => _newReports = v);
                    _setBool(NotificationPrefs.keyNewReports, v);
                  },
                ),
                const SizedBox(height: 12),
                _SectionLabel('Emergencias'),
                _SwitchRow(
                  icon: Icons.warning_amber_outlined,
                  title: 'SOS de mis contactos',
                  subtitle: 'Avisar si alguno de mis contactos activa una alerta SOS',
                  value: _sosFromContacts,
                  onChanged: (v) {
                    setState(() => _sosFromContacts = v);
                    _setBool(NotificationPrefs.keySosFromContacts, v);
                  },
                ),
                const SizedBox(height: 12),
                _SectionLabel('General'),
                _SwitchRow(
                  icon: Icons.volume_up_outlined,
                  title: 'Sonido',
                  subtitle: 'Reproducir sonido al recibir una notificación',
                  value: _sound,
                  onChanged: (v) {
                    setState(() => _sound = v);
                    _setBool(NotificationPrefs.keySound, v);
                  },
                ),
              ],
            ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(text.toUpperCase(),
          style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor, width: 0.5),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Icon(icon, color: AppColors.textSecondary, size: 20),
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}

class _RadiusSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  const _RadiusSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Radio de aviso', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const Spacer(),
              Text('${value.toStringAsFixed(1)} km',
                  style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.borderColor,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: 0.2,
              max: 5.0,
              divisions: 24,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

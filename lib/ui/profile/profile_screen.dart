import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../auth/login_screen.dart';
import '../auth/splash_screen.dart' show GradientButton;
import 'report_history_screen.dart';
import '../sos/sos_contacts_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  const Expanded(
                    child: Text('Mi perfil',
                        style: TextStyle(color: AppColors.textPrimary,
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.textSecondary, size: 20),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Avatar
              _Avatar(initials: user?.getInitials() ?? '??'),
              const SizedBox(height: 10),
              Text(user?.fullName ?? 'Usuario',
                  style: const TextStyle(color: AppColors.textPrimary,
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('${user?.email ?? ''} · Berazategui',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              const SizedBox(height: 16),
              // Stats
              Row(
                children: [
                  _StatBox(value: '${user?.reportsCount ?? 0}', label: 'Reportes'),
                  const SizedBox(width: 8),
                  _StatBox(value: '${user?.reputation ?? 5.0}', label: 'Reputación'),
                  const SizedBox(width: 8),
                  _StatBox(value: '${user?.alertsReceived ?? 0}', label: 'Alertas'),
                ],
              ),
              const SizedBox(height: 16),
              // Menu items
              _MenuItem(
                icon: Icons.description_outlined,
                label: 'Mis reportes',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportHistoryScreen())),
              ),
              _MenuItem(
                icon: Icons.people_outline,
                label: 'Contactos SOS',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SosContactsScreen())),
              ),
              _MenuItem(
                icon: Icons.notifications_outlined,
                label: 'Notificaciones',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.shield_outlined,
                label: 'Privacidad y seguridad',
                onTap: () {},
              ),
              const Divider(color: AppColors.borderColor),
              _MenuItem(
                icon: Icons.logout,
                label: 'Cerrar sesión',
                labelColor: AppColors.primary,
                iconColor: AppColors.primary,
                showChevron: false,
                onTap: () async {
                  context.read<AuthProvider>().logout();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.edit, size: 14, color: AppColors.primary),
                label: const Text('Editar perfil',
                    style: TextStyle(color: AppColors.primary, fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 0.5),
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Edit Profile Screen ───────────────────────────────────────
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameCtrl  = TextEditingController(text: user?.fullName ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>().updateProfile(
      _nameCtrl.text.trim(),
      _phoneCtrl.text.trim(),
    );
    if (mounted) {
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado'),
              backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.read<AuthProvider>().errorMessage ?? 'Error'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              _Avatar(initials: user?.getInitials() ?? '??'),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (v) => (v == null || v.trim().length < 3) ? 'Mínimo 3 caracteres' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                enabled: false,
                initialValue: user?.email ?? '',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'Email (solo lectura)',
                  filled: true,
                  fillColor: AppColors.cardBg,
                ),
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: 'Guardar cambios',
                loading: auth.state == AuthState.loading,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68, height: 68,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(initials,
            style: const TextStyle(color: Colors.white,
                fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value, label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor, width: 0.5),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(color: AppColors.textPrimary,
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? labelColor, iconColor;
  final bool showChevron;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: TextStyle(color: labelColor ?? AppColors.textPrimary, fontSize: 14)),
            ),
            if (showChevron)
              const Icon(Icons.chevron_right, color: AppColors.borderColor, size: 18),
          ],
        ),
      ),
    );
  }
}

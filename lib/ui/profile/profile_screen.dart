import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors_x.dart';
import '../../data/repositories/repositories.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/login_screen.dart';
import '../auth/splash_screen.dart' show GradientButton;
import 'report_history_screen.dart';
import '../sos/sos_contacts_screen.dart';
import 'notification_settings_screen.dart';
import 'privacy_screen.dart';
import 'language_screen.dart';
import 'theme_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.colors.cardBg,
        title: Text(t.profileLogoutConfirmTitle, style: TextStyle(color: context.colors.textPrimary)),
        content: Text(t.profileLogoutConfirmBody, style: TextStyle(color: context.colors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.profileMenuLogout, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<AuthProvider>().logout();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                  Expanded(
                    child: Text(t.profileTitle,
                        style: TextStyle(color: context.colors.textPrimary,
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: context.colors.textSecondary, size: 20),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen())),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Avatar (foto real si existe, sino iniciales)
              _Avatar(initials: user?.getInitials() ?? '??', photoUrl: user?.photoUrl),
              const SizedBox(height: 10),
              Text(user?.fullName ?? 'Usuario',
                  style: TextStyle(color: context.colors.textPrimary,
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('${user?.email ?? ''} · Berazategui',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
              const SizedBox(height: 16),
              // Stats
              Row(
                children: [
                  _StatBox(value: '${user?.reportsCount ?? 0}', label: t.profileReports),
                  const SizedBox(width: 8),
                  _StatBox(value: '${user?.reputation ?? 5.0}', label: t.profileReputation),
                  const SizedBox(width: 8),
                  _StatBox(value: '${user?.alertsReceived ?? 0}', label: t.profileAlerts),
                ],
              ),
              const SizedBox(height: 16),
              // Menu items
              _MenuItem(
                icon: Icons.description_outlined,
                label: t.profileMenuReports,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportHistoryScreen())),
              ),
              _MenuItem(
                icon: Icons.people_outline,
                label: t.profileMenuContacts,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SosContactsScreen())),
              ),
              _MenuItem(
                icon: Icons.notifications_outlined,
                label: t.profileMenuNotifications,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())),
              ),
              _MenuItem(
                icon: Icons.shield_outlined,
                label: t.profileMenuPrivacy,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PrivacyScreen())),
              ),
              _MenuItem(
                icon: Icons.language_outlined,
                label: t.profileMenuLanguage,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LanguageScreen())),
              ),
              _MenuItem(
                icon: Icons.dark_mode_outlined,
                label: t.profileMenuTheme,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ThemeScreen())),
              ),
              _MenuItem(
                icon: Icons.help_outline,
                label: t.profileMenuHelp,
                onTap: () => _openSupportEmail(context),
              ),
              _MenuItem(
                icon: Icons.info_outline,
                label: t.profileMenuAbout,
                onTap: () => _showAboutDialog(context),
              ),
              Divider(color: context.colors.borderColor),
              _MenuItem(
                icon: Icons.logout,
                label: t.profileMenuLogout,
                labelColor: AppColors.primary,
                iconColor: AppColors.primary,
                showChevron: false,
                onTap: () => _confirmLogout(context),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.edit, size: 14, color: AppColors.primary),
                label: Text(t.profileEditButton,
                    style: const TextStyle(color: AppColors.primary, fontSize: 13)),
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

  Future<void> _openSupportEmail(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final uri = Uri(
      scheme: 'mailto',
      path: 'soporte@guardianapp.com',
      query: 'subject=Ayuda con Guardian',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.profileNoEmailApp), backgroundColor: AppColors.warn),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.colors.cardBg,
        title: Text(t.appName, style: TextStyle(color: context.colors.textPrimary)),
        content: Text(t.profileAboutBody,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.close, style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// EDIT PROFILE SCREEN
// ═══════════════════════════════════════════════════════════════
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  final _formKey = GlobalKey<FormState>();
  final _photoRepo = PhotoRepository();

  bool _uploadingPhoto = false;

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
    final t = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>().updateProfile(
      _nameCtrl.text.trim(),
      _phoneCtrl.text.trim(),
    );
    if (mounted) {
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.editProfileSuccess), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.read<AuthProvider>().errorMessage ?? t.errorGeneric),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _pickAndUploadPhoto(ImageSource source) async {
    final t = AppLocalizations.of(context)!;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80, maxWidth: 1024);
    if (picked == null) return;

    setState(() => _uploadingPhoto = true);
    try {
      final url = await _photoRepo.uploadProfilePhoto(File(picked.path));
      final ok = await context.read<AuthProvider>().updatePhotoUrl(url);
      if (mounted) {
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.editProfileSuccess), backgroundColor: AppColors.success),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.editProfilePhotoError), backgroundColor: AppColors.error),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.editProfilePhotoError), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _removePhoto() async {
    setState(() => _uploadingPhoto = true);
    await context.read<AuthProvider>().updatePhotoUrl('');
    if (mounted) setState(() => _uploadingPhoto = false);
  }

  void _showPhotoOptions() {
    final t = AppLocalizations.of(context)!;
    final user = context.read<AuthProvider>().user;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.cardBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(t.editProfilePhotoTitle,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
              title: Text(t.editProfilePhotoCamera, style: TextStyle(color: context.colors.textPrimary)),
              onTap: () { Navigator.pop(context); _pickAndUploadPhoto(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
              title: Text(t.editProfilePhotoGallery, style: TextStyle(color: context.colors.textPrimary)),
              onTap: () { Navigator.pop(context); _pickAndUploadPhoto(ImageSource.gallery); },
            ),
            if (user?.photoUrl.isNotEmpty ?? false)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: Text(t.editProfilePhotoRemove, style: const TextStyle(color: AppColors.error)),
                onTap: () { Navigator.pop(context); _removePhoto(); },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.editProfileTitle),
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
              GestureDetector(
                onTap: _uploadingPhoto ? null : _showPhotoOptions,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _Avatar(initials: user?.getInitials() ?? '??', photoUrl: user?.photoUrl, size: 88),
                    if (_uploadingPhoto)
                      Container(
                        width: 88, height: 88,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                        child: const Center(
                          child: SizedBox(width: 24, height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                        ),
                      )
                    else
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: context.colors.cardBg, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                decoration: InputDecoration(labelText: t.editProfileFullName),
                validator: (v) => (v == null || v.trim().length < 3) ? t.registerNameTooShort : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                decoration: InputDecoration(labelText: t.editProfilePhone),
              ),
              const SizedBox(height: 12),
              TextFormField(
                enabled: false,
                initialValue: user?.email ?? '',
                style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: t.editProfileEmailReadonly,
                  filled: true,
                  fillColor: context.colors.cardBg,
                ),
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: t.editProfileSave,
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
  final String? photoUrl;
  final double size;
  const _Avatar({required this.initials, this.photoUrl, this.size = 68});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasPhoto ? null : const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: hasPhoto
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                width: size, height: size,
                placeholder: (_, __) => const Center(
                  child: SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                ),
                errorWidget: (_, __, ___) => Center(
                  child: Text(initials,
                      style: TextStyle(color: Colors.white, fontSize: size * 0.35, fontWeight: FontWeight.bold)),
                ),
              ),
            )
          : Center(
              child: Text(initials,
                  style: TextStyle(color: Colors.white, fontSize: size * 0.35, fontWeight: FontWeight.bold)),
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
          color: context.colors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.colors.borderColor, width: 0.5),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(color: context.colors.textPrimary,
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: context.colors.textSecondary, fontSize: 10)),
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
            Icon(icon, color: iconColor ?? context.colors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: TextStyle(color: labelColor ?? context.colors.textPrimary, fontSize: 14)),
            ),
            if (showChevron)
              Icon(Icons.chevron_right, color: context.colors.borderColor, size: 18),
          ],
        ),
      ),
    );
  }
}

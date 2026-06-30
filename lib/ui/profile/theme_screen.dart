import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors_x.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/theme_provider.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();
    final current = themeProvider.themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.themeTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _OptionTile(
            icon: Icons.brightness_auto_outlined,
            label: t.themeSystem,
            selected: current == ThemeMode.system,
            onTap: () => context.read<ThemeProvider>().setThemeMode(ThemeMode.system),
          ),
          _OptionTile(
            icon: Icons.light_mode_outlined,
            label: t.themeLight,
            selected: current == ThemeMode.light,
            onTap: () => context.read<ThemeProvider>().setThemeMode(ThemeMode.light),
          ),
          _OptionTile(
            icon: Icons.dark_mode_outlined,
            label: t.themeDark,
            selected: current == ThemeMode.dark,
            onTap: () => context.read<ThemeProvider>().setThemeMode(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _OptionTile({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? AppColors.primary : context.colors.borderColor,
          width: selected ? 1 : 0.5,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: context.colors.textSecondary),
        title: Text(label, style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
        trailing: selected
            ? const Icon(Icons.check_circle, color: AppColors.primary)
            : Icon(Icons.circle_outlined, color: context.colors.borderColor),
        onTap: onTap,
      ),
    );
  }
}

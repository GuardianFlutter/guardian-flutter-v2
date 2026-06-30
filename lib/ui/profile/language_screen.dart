import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors_x.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/locale_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();
    final current = localeProvider.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.languageTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _OptionTile(
            label: t.languageSystemDefault,
            selected: current == null,
            onTap: () => context.read<LocaleProvider>().setSystemDefault(),
          ),
          _OptionTile(
            label: t.languageSpanish,
            selected: current?.languageCode == 'es',
            onTap: () => context.read<LocaleProvider>().setSpanish(),
          ),
          _OptionTile(
            label: t.languageEnglish,
            selected: current?.languageCode == 'en',
            onTap: () => context.read<LocaleProvider>().setEnglish(),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _OptionTile({required this.label, required this.selected, required this.onTap});

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
        title: Text(label, style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
        trailing: selected
            ? const Icon(Icons.check_circle, color: AppColors.primary)
            : Icon(Icons.circle_outlined, color: context.colors.borderColor),
        onTap: onTap,
      ),
    );
  }
}

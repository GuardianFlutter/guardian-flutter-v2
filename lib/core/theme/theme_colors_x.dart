import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Helper para que los widgets usen el color correcto según el tema
/// activo (claro u oscuro) sin tener que repetir `Theme.of(context)`
/// en todos lados.
///
/// Uso: `context.colors.textPrimary` en vez de `AppColors.textPrimary`.
///
/// IMPORTANTE: las pantallas viejas que usan `AppColors.textPrimary`
/// directamente (hardcodeado) van a seguir viéndose con colores de
/// modo oscuro incluso en modo claro. Para que el cambio de tema se
/// vea bien en TODA la app, hay que ir reemplazando esos usos por
/// `context.colors.xxx` a medida que se editan las pantallas.
extension ThemeColorsX on BuildContext {
  AppColorScheme get colors => Theme.of(this).brightness == Brightness.dark
      ? AppColorScheme.dark()
      : AppColorScheme.light();
}

class AppColorScheme {
  final Color bg;
  final Color bgDarker;
  final Color cardBg;
  final Color navBg;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const AppColorScheme._({
    required this.bg,
    required this.bgDarker,
    required this.cardBg,
    required this.navBg,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  factory AppColorScheme.dark() => const AppColorScheme._(
    bg: AppColors.bgDark,
    bgDarker: AppColors.bgDarker,
    cardBg: AppColors.cardBg,
    navBg: AppColors.navBg,
    borderColor: AppColors.borderColor,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
  );

  factory AppColorScheme.light() => const AppColorScheme._(
    bg: Color(0xFFF7F7FA),
    bgDarker: Color(0xFFEDEEF2),
    cardBg: Color(0xFFFFFFFF),
    navBg: Color(0xFFFFFFFF),
    borderColor: Color(0xFFE2E4ED),
    textPrimary: Color(0xFF1A1F2E),
    textSecondary: Color(0xFF6B7280),
  );
}

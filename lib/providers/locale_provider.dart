import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Maneja el idioma activo de la app.
///
/// `locale == null` significa "seguir el idioma del dispositivo"
/// (Flutter usa el `localeResolutionCallback` / la lista de
/// `supportedLocales` más cercana al idioma del sistema).
class LocaleProvider extends ChangeNotifier {
  static const _prefsKey = 'app_locale_code'; // 'es' | 'en' | '' (sistema)

  Locale? _locale;
  bool _loaded = false;

  Locale? get locale => _locale;
  bool get loaded => _loaded;

  /// Carga la preferencia guardada. Llamar una vez al iniciar la app
  /// (antes de mostrar el MaterialApp, o se puede mostrar con el
  /// valor por defecto y dejar que se re-renderice cuando termine).
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code == null || code.isEmpty) {
      _locale = null; // sigue al sistema
    } else {
      _locale = Locale(code);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.setString(_prefsKey, '');
    } else {
      await prefs.setString(_prefsKey, locale.languageCode);
    }
  }

  /// Atajos usados en la pantalla de selección de idioma.
  Future<void> setSpanish() => setLocale(const Locale('es'));
  Future<void> setEnglish() => setLocale(const Locale('en'));
  Future<void> setSystemDefault() => setLocale(null);
}

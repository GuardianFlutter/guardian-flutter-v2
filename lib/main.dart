import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'providers/providers.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'l10n/generated/app_localizations.dart';
import 'ui/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cargamos las preferencias de idioma/tema ANTES de levantar la UI,
  // para evitar el parpadeo de mostrar el tema/idioma por defecto y
  // luego cambiar a la preferencia guardada un instante después.
  final localeProvider = LocaleProvider();
  final themeProvider = ThemeProvider();
  await Future.wait([
    localeProvider.load(),
    themeProvider.load(),
  ]);

  runApp(GuardianApp(
    localeProvider: localeProvider,
    themeProvider: themeProvider,
  ));
}

class GuardianApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  final ThemeProvider themeProvider;

  const GuardianApp({
    super.key,
    required this.localeProvider,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => SosProvider()),
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, locale, theme, _) {
          return MaterialApp(
            title: 'Guardian',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode,
            locale: locale.locale, // null => sigue el idioma del sistema
            supportedLocales: const [
              Locale('es'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

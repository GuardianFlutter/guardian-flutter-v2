# Guardian Flutter — Inicio rápido

## Pasos para tener la app corriendo

### 1. Crear el proyecto Flutter
```bash
flutter create --org com.catedra --project-name guardian guardian_app
cd guardian_app
```

### 2. Copiar los archivos de este proyecto
Copiar la carpeta `lib/` completa dentro de `guardian_app/lib/`
Reemplazar `pubspec.yaml` con el del proyecto

### 3. Instalar dependencias
```bash
flutter pub get
```

### 4. Configurar Firebase
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=seguridadciudadana-4296f
# Elegir Android cuando pregunte
# Esto genera lib/firebase_options.dart automáticamente
```

### 5. Reemplazar AndroidManifest.xml
Copiar el `android/AndroidManifest.xml` de este proyecto al proyecto Flutter en:
`guardian_app/android/app/src/main/AndroidManifest.xml`

### 6. Correr la app
```bash
# Con emulador o dispositivo Android conectado
flutter run
```

---

## Solución de problemas comunes

### "flutter: command not found"
- Verificar que `C:\flutter\bin` está en el PATH
- Reiniciar la terminal

### Error de compilación Firebase
- Verificar que `lib/firebase_options.dart` fue generado por flutterfire
- Correr `flutterfire configure` de nuevo si hace falta

### Mapa no aparece
- Verificar conexión a internet
- OpenStreetMap no requiere API key, funciona solo con internet

### "Multidex" error en Android
Agregar en `android/app/build.gradle`:
```groovy
defaultConfig {
    multiDexEnabled true
}
dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

### Build lento en AMD FX-6300
Flutter debería compilar más rápido que Gradle para Android.
Si igual es lento, agregar en `android/gradle.properties`:
```
org.gradle.jvmargs=-Xmx1536m -XX:+UseSerialGC
org.gradle.daemon=false
```

---

## Estructura de archivos generada

```
lib/
├── main.dart                          ✅ Entry point + Firebase + Provider
├── firebase_options.dart              ← generado por flutterfire
├── core/
│   ├── constants/app_colors.dart      ✅ Colores del diseño
│   └── theme/app_theme.dart           ✅ Tema oscuro completo
├── data/
│   ├── models/models.dart             ✅ UserModel, ReportModel, AlertModel
│   └── repositories/repositories.dart ✅ Auth, Report, SOS, Location, Photo
├── providers/
│   └── providers.dart                 ✅ AuthProvider, ReportProvider, SosProvider
└── ui/
    ├── auth/
    │   ├── splash_screen.dart         ✅ Splash + GradientButton + ShieldPainter
    │   ├── login_screen.dart          ✅ Login completo
    │   └── register_screen.dart       ✅ Register + ForgotPassword
    ├── main_screen.dart               ✅ BottomNavigation container
    ├── home/home_screen.dart          ✅ Feed de reportes + alertas
    ├── map/map_screen.dart            ✅ flutter_map + GPS + proximidad
    ├── report/
    │   ├── report_screen.dart         ✅ Formulario completo + foto + GPS
    │   └── report_detail_screen.dart  ✅ Detalle del reporte
    ├── sos/
    │   ├── sos_screen.dart            ✅ Hold 3s + animaciones + vibración
    │   └── sos_contacts_screen.dart   ✅ CRUD contactos SOS
    └── profile/
        ├── profile_screen.dart        ✅ Perfil + edición
        └── report_history_screen.dart ✅ Historial de reportes del usuario
```

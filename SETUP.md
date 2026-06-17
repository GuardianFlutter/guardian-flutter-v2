# Guardian Flutter — Guía de Setup Completo

## 1. Instalar Flutter en Windows

### Paso 1 — Descargar Flutter SDK
1. Ir a https://docs.flutter.dev/get-started/install/windows
2. Descargar el archivo ZIP (Flutter SDK para Windows)
3. Extraer en `C:\flutter` (NO en `C:\Program Files`, sin espacios en la ruta)

### Paso 2 — Agregar Flutter al PATH
1. Buscar "Variables de entorno" en el menú inicio
2. En "Variables del sistema" → editar `Path`
3. Agregar: `C:\flutter\bin`
4. Reiniciar la terminal

### Paso 3 — Verificar instalación
```bash
flutter doctor
```
Debe mostrar checkmarks en Flutter, Android SDK, y Android Studio.

### Paso 4 — Aceptar licencias Android
```bash
flutter doctor --android-licenses
# Presionar "y" en todo
```

---

## 2. Crear el proyecto Flutter

```bash
# En la carpeta donde quieras el proyecto
flutter create --org com.catedra --project-name guardian guardian_app
cd guardian_app
```

---

## 3. Configurar Firebase

### Instalar FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

Agregar al PATH si pide:
- Windows: `%LOCALAPPDATA%\Pub\Cache\bin`

### Conectar con el proyecto Firebase existente
```bash
flutterfire configure --project=seguridadciudadana-4296f
```
- Seleccionar Android cuando pregunte plataformas
- Esto genera `lib/firebase_options.dart` automáticamente

---

## 4. Reemplazar pubspec.yaml

Reemplazar el contenido de `pubspec.yaml` con el archivo `pubspec.yaml` de este proyecto.

---

## 5. Estructura de carpetas a crear

```
lib/
├── main.dart
├── firebase_options.dart        ← generado por flutterfire
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── report_model.dart
│   │   └── alert_model.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── report_repository.dart
│       ├── sos_repository.dart
│       └── location_repository.dart
├── providers/
│   ├── auth_provider.dart
│   ├── report_provider.dart
│   └── sos_provider.dart
└── ui/
    ├── auth/
    │   ├── splash_screen.dart
    │   ├── login_screen.dart
    │   └── register_screen.dart
    ├── main_screen.dart          ← bottom nav container
    ├── home/
    │   └── home_screen.dart
    ├── map/
    │   └── map_screen.dart
    ├── report/
    │   ├── report_screen.dart
    │   └── report_detail_screen.dart
    ├── sos/
    │   └── sos_screen.dart
    └── profile/
        └── profile_screen.dart
```

### Crear todas las carpetas de una vez (ejecutar en la raíz del proyecto):
```bash
mkdir -p lib/core/constants lib/core/theme lib/data/models lib/data/repositories lib/providers lib/ui/auth lib/ui/home lib/ui/map lib/ui/report lib/ui/sos lib/ui/profile
```

---

## 6. Correr el proyecto

```bash
# Con un emulador o dispositivo conectado
flutter run

# Solo para verificar que compila
flutter build apk --debug
```

---

## Notas para AMD FX-6300 / 8GB RAM

Flutter en sí compila más rápido que Gradle para Android.
El primer build tarda ~5 min, los siguientes son mucho más rápidos por caché.

Para builds de debug (desarrollo):
```bash
flutter run --debug
```

Para generar APK final:
```bash
flutter build apk --release
```

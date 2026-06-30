// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Guardian';

  @override
  String get appTagline => 'Seguridad ciudadana\ninteligente y colaborativa';

  @override
  String get navHome => 'Inicio';

  @override
  String get navMap => 'Mapa';

  @override
  String get navReport => 'Reportar';

  @override
  String get navSos => 'SOS';

  @override
  String get navProfile => 'Perfil';

  @override
  String get loginTitle => 'Iniciá sesión para continuar';

  @override
  String get loginEmail => 'Correo electrónico';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginOr => 'o';

  @override
  String get loginGoogle => 'Continuar con Google';

  @override
  String get loginNoAccount => '¿No tenés cuenta? ';

  @override
  String get loginRegisterLink => 'Registrate';

  @override
  String get loginErrorGeneric => 'Error';

  @override
  String get loginInvalidEmail => 'Ingresá un email válido';

  @override
  String get loginEmptyPassword => 'Ingresá tu contraseña';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerHaveAccount => '¿Ya tenés cuenta?';

  @override
  String get registerFullName => 'Nombre completo';

  @override
  String get registerNameTooShort => 'Mínimo 3 caracteres';

  @override
  String get registerEmail => 'Correo electrónico';

  @override
  String get registerInvalidEmail => 'Email inválido';

  @override
  String get registerPhone => 'Teléfono';

  @override
  String get registerInvalidPhone => 'Teléfono inválido';

  @override
  String get registerPassword => 'Contraseña';

  @override
  String get registerPasswordTooShort => 'Mínimo 6 caracteres';

  @override
  String get registerConfirmPassword => 'Confirmar contraseña';

  @override
  String get registerPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get registerStrengthLabel => 'Fortaleza';

  @override
  String get registerStrengthVeryWeak => 'Muy débil';

  @override
  String get registerStrengthWeak => 'Débil';

  @override
  String get registerStrengthMedium => 'Media';

  @override
  String get registerStrengthStrong => 'Fuerte';

  @override
  String get registerStrengthVeryStrong => 'Muy fuerte';

  @override
  String get registerSubmit => 'Crear cuenta';

  @override
  String get forgotPasswordTitle => 'Recuperar contraseña';

  @override
  String get forgotPasswordBody =>
      'Ingresá tu correo y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get forgotPasswordSubmit => 'Enviar correo de recuperación';

  @override
  String get forgotPasswordBackToLogin => 'Volver al inicio de sesión';

  @override
  String get forgotPasswordSuccess =>
      'Revisá tu correo para restablecer la contraseña';

  @override
  String get homeWelcome => 'Bienvenido/a 👋';

  @override
  String homeGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get homeRecentIncidents => 'Incidentes recientes';

  @override
  String get homeClearFilter => 'Limpiar filtro';

  @override
  String get homeNoReports =>
      'No hay reportes aún.\nSé el primero en reportar.';

  @override
  String get homeNoReportsFiltered => 'No hay incidentes de este tipo todavía.';

  @override
  String get homeLastIncident => '⚠ Último incidente reportado';

  @override
  String get homeNotificationHint =>
      'Configurá tus preferencias en Perfil → Notificaciones';

  @override
  String get homeFilterRobos => 'Robos';

  @override
  String get homeFilterAccidentes => 'Accidentes';

  @override
  String get homeFilterZonas => 'Zonas';

  @override
  String get homeFilterOtros => 'Otros';

  @override
  String get mapTitle => 'Mapa en vivo';

  @override
  String get mapRealtime => 'Tiempo real';

  @override
  String get mapLegendRobo => 'Robo';

  @override
  String get mapLegendViolencia => 'Violencia';

  @override
  String get mapLegendZona => 'Zona';

  @override
  String get mapActive => 'Activo';

  @override
  String get mapOngoing => 'Vigente';

  @override
  String mapProximityAlert(String title, String distance) {
    return '⚠ $title a ${distance}m de vos';
  }

  @override
  String get reportNewTitle => 'Nuevo Reporte';

  @override
  String get reportCategoryLabel => 'Categoría del incidente';

  @override
  String get reportTitleField => 'Título del incidente';

  @override
  String get reportTitleRequired => 'Ingresá un título';

  @override
  String get reportDescriptionLabel => 'Descripción';

  @override
  String get reportDescriptionField => 'Describí lo que ocurrió…';

  @override
  String get reportDescriptionRequired => 'Ingresá una descripción';

  @override
  String get reportLocationLabel => 'Ubicación';

  @override
  String get reportLocationDetecting => 'Detectando ubicación...';

  @override
  String get reportLocationDenied => 'Permiso denegado';

  @override
  String get reportLocationFailed => 'No se pudo detectar';

  @override
  String get reportGpsButton => 'GPS';

  @override
  String get reportAddPhoto => 'Agregar foto';

  @override
  String get reportSubmit => 'Enviar reporte';

  @override
  String get reportSuccessMessage => 'Reporte enviado exitosamente';

  @override
  String get reportLoginRequired => 'Debés iniciar sesión';

  @override
  String get reportCatRoboMoto => 'Robo moto';

  @override
  String get reportCatAccidente => 'Accidente';

  @override
  String get reportCatViolencia => 'Violencia';

  @override
  String get reportCatCalleOscura => 'Calle oscura';

  @override
  String get reportCatZonaPeligrosa => 'Zona peligrosa';

  @override
  String get reportCatOtro => 'Otro';

  @override
  String get reportDetailTitle => 'Detalle del reporte';

  @override
  String get reportDetailNotFound => 'Reporte no encontrado';

  @override
  String get myReportsTitle => 'Mis reportes';

  @override
  String get myReportsEmpty => 'No has enviado reportes aún';

  @override
  String get sosTitle => 'Alerta de emergencia';

  @override
  String get sosTapToCancel => 'Tocá el botón para cancelar';

  @override
  String get sosHoldInstruction => 'Mantené presionado 3 segundos';

  @override
  String get sosActivated => '🚨 ALERTA SOS ACTIVADA';

  @override
  String get sosCancelled => 'Alerta SOS cancelada';

  @override
  String get sosSendingMessages => 'Notificando a tus contactos…';

  @override
  String get sosLocation => 'Ubicación';

  @override
  String get sosGpsActive => 'GPS activo';

  @override
  String get sosGpsOn => 'ON';

  @override
  String get sosOnline => 'Online';

  @override
  String get sosContacts => 'Contactos';

  @override
  String get sosInfoTitle => '¿Qué hace el SOS?';

  @override
  String get sosInfoLocation => 'Envía tu ubicación en tiempo real';

  @override
  String get sosInfoNotify => 'Notifica a tus contactos por WhatsApp o SMS';

  @override
  String get sosInfoVibration => 'Activa vibración de alerta';

  @override
  String get sosInfoReport => 'Crea un reporte automático en la app';

  @override
  String get sosStatusActive => 'Estado: ALERTA ACTIVA';

  @override
  String get sosStatusInactive => 'Estado: Inactivo';

  @override
  String get sosCall911 => 'Llamar 911';

  @override
  String get sosManageContacts => 'Contactos SOS';

  @override
  String get sosNoContactsTitle => 'No tenés contactos SOS';

  @override
  String get sosNoContactsBody =>
      'No vas a poder notificar a nadie automáticamente. ¿Querés agregar contactos ahora o continuar igual?';

  @override
  String get sosContinueAnyway => 'Continuar igual';

  @override
  String get sosAddContacts => 'Agregar contactos';

  @override
  String sosSentToAll(String count, String plural) {
    return 'Mensaje enviado a $count contacto$plural';
  }

  @override
  String sosSentPartial(String sent, String total) {
    return 'Mensaje enviado a $sent de $total contactos';
  }

  @override
  String get sosContactsTitle => 'Contactos SOS';

  @override
  String get sosContactsEmpty => 'No tenés contactos SOS';

  @override
  String get sosContactsEmptyHint =>
      'Agregá al menos uno para que reciba tu ubicación si activás el SOS.';

  @override
  String get sosContactsAddButton => 'Agregar contacto';

  @override
  String get sosContactsAddTitle => 'Agregar contacto SOS';

  @override
  String get sosContactsEditTitle => 'Editar contacto';

  @override
  String get sosContactsHint =>
      'Este contacto va a recibir tu ubicación por WhatsApp o SMS cuando actives el botón SOS.';

  @override
  String get sosContactsName => 'Nombre';

  @override
  String get sosContactsNameRequired => 'Requerido';

  @override
  String get sosContactsPhone => 'Teléfono (con código de país, ej: +54911...)';

  @override
  String get sosContactsPhoneInvalid => 'Teléfono inválido';

  @override
  String get sosContactsRelation => 'Relación (mamá, papá…)';

  @override
  String get sosContactsSave => 'Guardar contacto';

  @override
  String get sosContactsUpdate => 'Actualizar';

  @override
  String get sosContactsDeleteTitle => 'Eliminar contacto';

  @override
  String sosContactsDeleteConfirm(String name) {
    return '¿Eliminar a $name?';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get profileTitle => 'Mi perfil';

  @override
  String get profileReports => 'Reportes';

  @override
  String get profileReputation => 'Reputación';

  @override
  String get profileAlerts => 'Alertas';

  @override
  String get profileMenuReports => 'Mis reportes';

  @override
  String get profileMenuContacts => 'Contactos SOS';

  @override
  String get profileMenuNotifications => 'Notificaciones';

  @override
  String get profileMenuPrivacy => 'Privacidad y seguridad';

  @override
  String get profileMenuLanguage => 'Idioma';

  @override
  String get profileMenuTheme => 'Apariencia';

  @override
  String get profileMenuHelp => 'Ayuda y soporte';

  @override
  String get profileMenuAbout => 'Acerca de Guardian';

  @override
  String get profileMenuLogout => 'Cerrar sesión';

  @override
  String get profileEditButton => 'Editar perfil';

  @override
  String get profileLogoutConfirmTitle => 'Cerrar sesión';

  @override
  String get profileLogoutConfirmBody => '¿Seguro que querés cerrar sesión?';

  @override
  String get profileNoEmailApp => 'No se encontró una app de correo instalada';

  @override
  String get profileAboutBody =>
      'Guardian v1.0.0\n\nAplicación de seguridad ciudadana colaborativa. Reportá incidentes, visualizá alertas cercanas y notificá a tus contactos de confianza en caso de emergencia.\n\nProyecto académico — Berazategui.';

  @override
  String get close => 'Cerrar';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfileFullName => 'Nombre completo';

  @override
  String get editProfilePhone => 'Teléfono';

  @override
  String get editProfileEmailReadonly => 'Email (solo lectura)';

  @override
  String get editProfileSave => 'Guardar cambios';

  @override
  String get editProfileSuccess => 'Perfil actualizado';

  @override
  String get editProfilePhotoTitle => 'Foto de perfil';

  @override
  String get editProfilePhotoCamera => 'Tomar foto';

  @override
  String get editProfilePhotoGallery => 'Elegir de galería';

  @override
  String get editProfilePhotoRemove => 'Quitar foto';

  @override
  String get editProfilePhotoUploading => 'Subiendo foto…';

  @override
  String get editProfilePhotoError => 'No se pudo subir la foto';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsSectionAlerts => 'Alertas de incidentes';

  @override
  String get notificationsNearby => 'Alertas cercanas';

  @override
  String get notificationsNearbyDesc =>
      'Avisar cuando hay un incidente cerca de tu ubicación';

  @override
  String get notificationsRadius => 'Radio de aviso';

  @override
  String get notificationsNewReports => 'Nuevos reportes';

  @override
  String get notificationsNewReportsDesc =>
      'Avisar cuando se publica un reporte nuevo en tu zona';

  @override
  String get notificationsSectionEmergency => 'Emergencias';

  @override
  String get notificationsSosContacts => 'SOS de mis contactos';

  @override
  String get notificationsSosContactsDesc =>
      'Avisar si alguno de mis contactos activa una alerta SOS';

  @override
  String get notificationsSectionGeneral => 'General';

  @override
  String get notificationsSound => 'Sonido';

  @override
  String get notificationsSoundDesc =>
      'Reproducir sonido al recibir una notificación';

  @override
  String get privacyTitle => 'Privacidad y seguridad';

  @override
  String get privacyLocationTitle => 'Ubicación';

  @override
  String get privacyLocationBody =>
      'Tu ubicación se usa para mostrar incidentes cercanos en el mapa y para adjuntarla automáticamente cuando creás un reporte o activás una alerta SOS. Solo se comparte con tus contactos SOS al activar una alerta, nunca de forma pública.';

  @override
  String get privacyContactsTitle => 'Contactos SOS';

  @override
  String get privacyContactsBody =>
      'Los contactos que agregués se guardan de forma privada asociados a tu cuenta. Solo se usan para enviarles tu ubicación por WhatsApp o SMS cuando activás el botón SOS. Guardian no accede a tu lista de contactos del teléfono.';

  @override
  String get privacyReportsTitle => 'Reportes';

  @override
  String get privacyReportsBody =>
      'Los reportes que publicás son visibles para otros usuarios de la app con tu nombre de perfil. No se comparte tu email ni tu teléfono en los reportes públicos.';

  @override
  String get privacyStorageTitle => 'Almacenamiento de datos';

  @override
  String get privacyStorageBody =>
      'Los datos de tu cuenta, reportes y contactos SOS se almacenan en Firebase (Google Cloud). Las fotos de perfil y de los reportes se almacenan en un servicio externo (Cloudinary).';

  @override
  String get privacyDeleteTitle => 'Eliminar tu cuenta';

  @override
  String get privacyDeleteBody =>
      'Para solicitar la eliminación de tu cuenta y tus datos, contactá a la cátedra o al administrador del proyecto.';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystemDefault => 'Usar el idioma del dispositivo';

  @override
  String get themeTitle => 'Apariencia';

  @override
  String get themeSystem => 'Automático (según el sistema)';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get errorGeneric => 'Ocurrió un error';

  @override
  String get retry => 'Reintentar';
}

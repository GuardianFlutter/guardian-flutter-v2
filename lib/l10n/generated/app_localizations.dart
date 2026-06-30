import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Guardian'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In es, this message translates to:
  /// **'Seguridad ciudadana\ninteligente y colaborativa'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navMap.
  ///
  /// In es, this message translates to:
  /// **'Mapa'**
  String get navMap;

  /// No description provided for @navReport.
  ///
  /// In es, this message translates to:
  /// **'Reportar'**
  String get navReport;

  /// No description provided for @navSos.
  ///
  /// In es, this message translates to:
  /// **'SOS'**
  String get navSos;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciá sesión para continuar'**
  String get loginTitle;

  /// No description provided for @loginEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get loginPassword;

  /// No description provided for @loginForgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get loginForgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get loginButton;

  /// No description provided for @loginOr.
  ///
  /// In es, this message translates to:
  /// **'o'**
  String get loginOr;

  /// No description provided for @loginGoogle.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Google'**
  String get loginGoogle;

  /// No description provided for @loginNoAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tenés cuenta? '**
  String get loginNoAccount;

  /// No description provided for @loginRegisterLink.
  ///
  /// In es, this message translates to:
  /// **'Registrate'**
  String get loginRegisterLink;

  /// No description provided for @loginErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get loginErrorGeneric;

  /// No description provided for @loginInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Ingresá un email válido'**
  String get loginInvalidEmail;

  /// No description provided for @loginEmptyPassword.
  ///
  /// In es, this message translates to:
  /// **'Ingresá tu contraseña'**
  String get loginEmptyPassword;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get registerTitle;

  /// No description provided for @registerHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tenés cuenta?'**
  String get registerHaveAccount;

  /// No description provided for @registerFullName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get registerFullName;

  /// No description provided for @registerNameTooShort.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 3 caracteres'**
  String get registerNameTooShort;

  /// No description provided for @registerEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get registerEmail;

  /// No description provided for @registerInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Email inválido'**
  String get registerInvalidEmail;

  /// No description provided for @registerPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get registerPhone;

  /// No description provided for @registerInvalidPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono inválido'**
  String get registerInvalidPhone;

  /// No description provided for @registerPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get registerPassword;

  /// No description provided for @registerPasswordTooShort.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get registerPasswordTooShort;

  /// No description provided for @registerConfirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get registerConfirmPassword;

  /// No description provided for @registerPasswordMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get registerPasswordMismatch;

  /// No description provided for @registerStrengthLabel.
  ///
  /// In es, this message translates to:
  /// **'Fortaleza'**
  String get registerStrengthLabel;

  /// No description provided for @registerStrengthVeryWeak.
  ///
  /// In es, this message translates to:
  /// **'Muy débil'**
  String get registerStrengthVeryWeak;

  /// No description provided for @registerStrengthWeak.
  ///
  /// In es, this message translates to:
  /// **'Débil'**
  String get registerStrengthWeak;

  /// No description provided for @registerStrengthMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get registerStrengthMedium;

  /// No description provided for @registerStrengthStrong.
  ///
  /// In es, this message translates to:
  /// **'Fuerte'**
  String get registerStrengthStrong;

  /// No description provided for @registerStrengthVeryStrong.
  ///
  /// In es, this message translates to:
  /// **'Muy fuerte'**
  String get registerStrengthVeryStrong;

  /// No description provided for @registerSubmit.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get registerSubmit;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Recuperar contraseña'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In es, this message translates to:
  /// **'Ingresá tu correo y te enviaremos un enlace para restablecer tu contraseña.'**
  String get forgotPasswordBody;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In es, this message translates to:
  /// **'Enviar correo de recuperación'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordBackToLogin.
  ///
  /// In es, this message translates to:
  /// **'Volver al inicio de sesión'**
  String get forgotPasswordBackToLogin;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In es, this message translates to:
  /// **'Revisá tu correo para restablecer la contraseña'**
  String get forgotPasswordSuccess;

  /// No description provided for @homeWelcome.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido/a 👋'**
  String get homeWelcome;

  /// No description provided for @homeGreeting.
  ///
  /// In es, this message translates to:
  /// **'Hola, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeRecentIncidents.
  ///
  /// In es, this message translates to:
  /// **'Incidentes recientes'**
  String get homeRecentIncidents;

  /// No description provided for @homeClearFilter.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtro'**
  String get homeClearFilter;

  /// No description provided for @homeNoReports.
  ///
  /// In es, this message translates to:
  /// **'No hay reportes aún.\nSé el primero en reportar.'**
  String get homeNoReports;

  /// No description provided for @homeNoReportsFiltered.
  ///
  /// In es, this message translates to:
  /// **'No hay incidentes de este tipo todavía.'**
  String get homeNoReportsFiltered;

  /// No description provided for @homeLastIncident.
  ///
  /// In es, this message translates to:
  /// **'⚠ Último incidente reportado'**
  String get homeLastIncident;

  /// No description provided for @homeNotificationHint.
  ///
  /// In es, this message translates to:
  /// **'Configurá tus preferencias en Perfil → Notificaciones'**
  String get homeNotificationHint;

  /// No description provided for @homeFilterRobos.
  ///
  /// In es, this message translates to:
  /// **'Robos'**
  String get homeFilterRobos;

  /// No description provided for @homeFilterAccidentes.
  ///
  /// In es, this message translates to:
  /// **'Accidentes'**
  String get homeFilterAccidentes;

  /// No description provided for @homeFilterZonas.
  ///
  /// In es, this message translates to:
  /// **'Zonas'**
  String get homeFilterZonas;

  /// No description provided for @homeFilterOtros.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get homeFilterOtros;

  /// No description provided for @mapTitle.
  ///
  /// In es, this message translates to:
  /// **'Mapa en vivo'**
  String get mapTitle;

  /// No description provided for @mapRealtime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo real'**
  String get mapRealtime;

  /// No description provided for @mapLegendRobo.
  ///
  /// In es, this message translates to:
  /// **'Robo'**
  String get mapLegendRobo;

  /// No description provided for @mapLegendViolencia.
  ///
  /// In es, this message translates to:
  /// **'Violencia'**
  String get mapLegendViolencia;

  /// No description provided for @mapLegendZona.
  ///
  /// In es, this message translates to:
  /// **'Zona'**
  String get mapLegendZona;

  /// No description provided for @mapActive.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get mapActive;

  /// No description provided for @mapOngoing.
  ///
  /// In es, this message translates to:
  /// **'Vigente'**
  String get mapOngoing;

  /// No description provided for @mapProximityAlert.
  ///
  /// In es, this message translates to:
  /// **'⚠ {title} a {distance}m de vos'**
  String mapProximityAlert(String title, String distance);

  /// No description provided for @reportNewTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Reporte'**
  String get reportNewTitle;

  /// No description provided for @reportCategoryLabel.
  ///
  /// In es, this message translates to:
  /// **'Categoría del incidente'**
  String get reportCategoryLabel;

  /// No description provided for @reportTitleField.
  ///
  /// In es, this message translates to:
  /// **'Título del incidente'**
  String get reportTitleField;

  /// No description provided for @reportTitleRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresá un título'**
  String get reportTitleRequired;

  /// No description provided for @reportDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get reportDescriptionLabel;

  /// No description provided for @reportDescriptionField.
  ///
  /// In es, this message translates to:
  /// **'Describí lo que ocurrió…'**
  String get reportDescriptionField;

  /// No description provided for @reportDescriptionRequired.
  ///
  /// In es, this message translates to:
  /// **'Ingresá una descripción'**
  String get reportDescriptionRequired;

  /// No description provided for @reportLocationLabel.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get reportLocationLabel;

  /// No description provided for @reportLocationDetecting.
  ///
  /// In es, this message translates to:
  /// **'Detectando ubicación...'**
  String get reportLocationDetecting;

  /// No description provided for @reportLocationDenied.
  ///
  /// In es, this message translates to:
  /// **'Permiso denegado'**
  String get reportLocationDenied;

  /// No description provided for @reportLocationFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo detectar'**
  String get reportLocationFailed;

  /// No description provided for @reportGpsButton.
  ///
  /// In es, this message translates to:
  /// **'GPS'**
  String get reportGpsButton;

  /// No description provided for @reportAddPhoto.
  ///
  /// In es, this message translates to:
  /// **'Agregar foto'**
  String get reportAddPhoto;

  /// No description provided for @reportSubmit.
  ///
  /// In es, this message translates to:
  /// **'Enviar reporte'**
  String get reportSubmit;

  /// No description provided for @reportSuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'Reporte enviado exitosamente'**
  String get reportSuccessMessage;

  /// No description provided for @reportLoginRequired.
  ///
  /// In es, this message translates to:
  /// **'Debés iniciar sesión'**
  String get reportLoginRequired;

  /// No description provided for @reportCatRoboMoto.
  ///
  /// In es, this message translates to:
  /// **'Robo moto'**
  String get reportCatRoboMoto;

  /// No description provided for @reportCatAccidente.
  ///
  /// In es, this message translates to:
  /// **'Accidente'**
  String get reportCatAccidente;

  /// No description provided for @reportCatViolencia.
  ///
  /// In es, this message translates to:
  /// **'Violencia'**
  String get reportCatViolencia;

  /// No description provided for @reportCatCalleOscura.
  ///
  /// In es, this message translates to:
  /// **'Calle oscura'**
  String get reportCatCalleOscura;

  /// No description provided for @reportCatZonaPeligrosa.
  ///
  /// In es, this message translates to:
  /// **'Zona peligrosa'**
  String get reportCatZonaPeligrosa;

  /// No description provided for @reportCatOtro.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get reportCatOtro;

  /// No description provided for @reportDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle del reporte'**
  String get reportDetailTitle;

  /// No description provided for @reportDetailNotFound.
  ///
  /// In es, this message translates to:
  /// **'Reporte no encontrado'**
  String get reportDetailNotFound;

  /// No description provided for @myReportsTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis reportes'**
  String get myReportsTitle;

  /// No description provided for @myReportsEmpty.
  ///
  /// In es, this message translates to:
  /// **'No has enviado reportes aún'**
  String get myReportsEmpty;

  /// No description provided for @sosTitle.
  ///
  /// In es, this message translates to:
  /// **'Alerta de emergencia'**
  String get sosTitle;

  /// No description provided for @sosTapToCancel.
  ///
  /// In es, this message translates to:
  /// **'Tocá el botón para cancelar'**
  String get sosTapToCancel;

  /// No description provided for @sosHoldInstruction.
  ///
  /// In es, this message translates to:
  /// **'Mantené presionado 3 segundos'**
  String get sosHoldInstruction;

  /// No description provided for @sosActivated.
  ///
  /// In es, this message translates to:
  /// **'🚨 ALERTA SOS ACTIVADA'**
  String get sosActivated;

  /// No description provided for @sosCancelled.
  ///
  /// In es, this message translates to:
  /// **'Alerta SOS cancelada'**
  String get sosCancelled;

  /// No description provided for @sosSendingMessages.
  ///
  /// In es, this message translates to:
  /// **'Notificando a tus contactos…'**
  String get sosSendingMessages;

  /// No description provided for @sosLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get sosLocation;

  /// No description provided for @sosGpsActive.
  ///
  /// In es, this message translates to:
  /// **'GPS activo'**
  String get sosGpsActive;

  /// No description provided for @sosGpsOn.
  ///
  /// In es, this message translates to:
  /// **'ON'**
  String get sosGpsOn;

  /// No description provided for @sosOnline.
  ///
  /// In es, this message translates to:
  /// **'Online'**
  String get sosOnline;

  /// No description provided for @sosContacts.
  ///
  /// In es, this message translates to:
  /// **'Contactos'**
  String get sosContacts;

  /// No description provided for @sosInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Qué hace el SOS?'**
  String get sosInfoTitle;

  /// No description provided for @sosInfoLocation.
  ///
  /// In es, this message translates to:
  /// **'Envía tu ubicación en tiempo real'**
  String get sosInfoLocation;

  /// No description provided for @sosInfoNotify.
  ///
  /// In es, this message translates to:
  /// **'Notifica a tus contactos por WhatsApp o SMS'**
  String get sosInfoNotify;

  /// No description provided for @sosInfoVibration.
  ///
  /// In es, this message translates to:
  /// **'Activa vibración de alerta'**
  String get sosInfoVibration;

  /// No description provided for @sosInfoReport.
  ///
  /// In es, this message translates to:
  /// **'Crea un reporte automático en la app'**
  String get sosInfoReport;

  /// No description provided for @sosStatusActive.
  ///
  /// In es, this message translates to:
  /// **'Estado: ALERTA ACTIVA'**
  String get sosStatusActive;

  /// No description provided for @sosStatusInactive.
  ///
  /// In es, this message translates to:
  /// **'Estado: Inactivo'**
  String get sosStatusInactive;

  /// No description provided for @sosCall911.
  ///
  /// In es, this message translates to:
  /// **'Llamar 911'**
  String get sosCall911;

  /// No description provided for @sosManageContacts.
  ///
  /// In es, this message translates to:
  /// **'Contactos SOS'**
  String get sosManageContacts;

  /// No description provided for @sosNoContactsTitle.
  ///
  /// In es, this message translates to:
  /// **'No tenés contactos SOS'**
  String get sosNoContactsTitle;

  /// No description provided for @sosNoContactsBody.
  ///
  /// In es, this message translates to:
  /// **'No vas a poder notificar a nadie automáticamente. ¿Querés agregar contactos ahora o continuar igual?'**
  String get sosNoContactsBody;

  /// No description provided for @sosContinueAnyway.
  ///
  /// In es, this message translates to:
  /// **'Continuar igual'**
  String get sosContinueAnyway;

  /// No description provided for @sosAddContacts.
  ///
  /// In es, this message translates to:
  /// **'Agregar contactos'**
  String get sosAddContacts;

  /// No description provided for @sosSentToAll.
  ///
  /// In es, this message translates to:
  /// **'Mensaje enviado a {count} contacto{plural}'**
  String sosSentToAll(String count, String plural);

  /// No description provided for @sosSentPartial.
  ///
  /// In es, this message translates to:
  /// **'Mensaje enviado a {sent} de {total} contactos'**
  String sosSentPartial(String sent, String total);

  /// No description provided for @sosContactsTitle.
  ///
  /// In es, this message translates to:
  /// **'Contactos SOS'**
  String get sosContactsTitle;

  /// No description provided for @sosContactsEmpty.
  ///
  /// In es, this message translates to:
  /// **'No tenés contactos SOS'**
  String get sosContactsEmpty;

  /// No description provided for @sosContactsEmptyHint.
  ///
  /// In es, this message translates to:
  /// **'Agregá al menos uno para que reciba tu ubicación si activás el SOS.'**
  String get sosContactsEmptyHint;

  /// No description provided for @sosContactsAddButton.
  ///
  /// In es, this message translates to:
  /// **'Agregar contacto'**
  String get sosContactsAddButton;

  /// No description provided for @sosContactsAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Agregar contacto SOS'**
  String get sosContactsAddTitle;

  /// No description provided for @sosContactsEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar contacto'**
  String get sosContactsEditTitle;

  /// No description provided for @sosContactsHint.
  ///
  /// In es, this message translates to:
  /// **'Este contacto va a recibir tu ubicación por WhatsApp o SMS cuando actives el botón SOS.'**
  String get sosContactsHint;

  /// No description provided for @sosContactsName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get sosContactsName;

  /// No description provided for @sosContactsNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Requerido'**
  String get sosContactsNameRequired;

  /// No description provided for @sosContactsPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono (con código de país, ej: +54911...)'**
  String get sosContactsPhone;

  /// No description provided for @sosContactsPhoneInvalid.
  ///
  /// In es, this message translates to:
  /// **'Teléfono inválido'**
  String get sosContactsPhoneInvalid;

  /// No description provided for @sosContactsRelation.
  ///
  /// In es, this message translates to:
  /// **'Relación (mamá, papá…)'**
  String get sosContactsRelation;

  /// No description provided for @sosContactsSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar contacto'**
  String get sosContactsSave;

  /// No description provided for @sosContactsUpdate.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get sosContactsUpdate;

  /// No description provided for @sosContactsDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar contacto'**
  String get sosContactsDeleteTitle;

  /// No description provided for @sosContactsDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar a {name}?'**
  String sosContactsDeleteConfirm(String name);

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get profileTitle;

  /// No description provided for @profileReports.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get profileReports;

  /// No description provided for @profileReputation.
  ///
  /// In es, this message translates to:
  /// **'Reputación'**
  String get profileReputation;

  /// No description provided for @profileAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas'**
  String get profileAlerts;

  /// No description provided for @profileMenuReports.
  ///
  /// In es, this message translates to:
  /// **'Mis reportes'**
  String get profileMenuReports;

  /// No description provided for @profileMenuContacts.
  ///
  /// In es, this message translates to:
  /// **'Contactos SOS'**
  String get profileMenuContacts;

  /// No description provided for @profileMenuNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get profileMenuNotifications;

  /// No description provided for @profileMenuPrivacy.
  ///
  /// In es, this message translates to:
  /// **'Privacidad y seguridad'**
  String get profileMenuPrivacy;

  /// No description provided for @profileMenuLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get profileMenuLanguage;

  /// No description provided for @profileMenuTheme.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get profileMenuTheme;

  /// No description provided for @profileMenuHelp.
  ///
  /// In es, this message translates to:
  /// **'Ayuda y soporte'**
  String get profileMenuHelp;

  /// No description provided for @profileMenuAbout.
  ///
  /// In es, this message translates to:
  /// **'Acerca de Guardian'**
  String get profileMenuAbout;

  /// No description provided for @profileMenuLogout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get profileMenuLogout;

  /// No description provided for @profileEditButton.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get profileEditButton;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileLogoutConfirmBody.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que querés cerrar sesión?'**
  String get profileLogoutConfirmBody;

  /// No description provided for @profileNoEmailApp.
  ///
  /// In es, this message translates to:
  /// **'No se encontró una app de correo instalada'**
  String get profileNoEmailApp;

  /// No description provided for @profileAboutBody.
  ///
  /// In es, this message translates to:
  /// **'Guardian v1.0.0\n\nAplicación de seguridad ciudadana colaborativa. Reportá incidentes, visualizá alertas cercanas y notificá a tus contactos de confianza en caso de emergencia.\n\nProyecto académico — Berazategui.'**
  String get profileAboutBody;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @editProfileTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editProfileTitle;

  /// No description provided for @editProfileFullName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get editProfileFullName;

  /// No description provided for @editProfilePhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get editProfilePhone;

  /// No description provided for @editProfileEmailReadonly.
  ///
  /// In es, this message translates to:
  /// **'Email (solo lectura)'**
  String get editProfileEmailReadonly;

  /// No description provided for @editProfileSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get editProfileSave;

  /// No description provided for @editProfileSuccess.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado'**
  String get editProfileSuccess;

  /// No description provided for @editProfilePhotoTitle.
  ///
  /// In es, this message translates to:
  /// **'Foto de perfil'**
  String get editProfilePhotoTitle;

  /// No description provided for @editProfilePhotoCamera.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get editProfilePhotoCamera;

  /// No description provided for @editProfilePhotoGallery.
  ///
  /// In es, this message translates to:
  /// **'Elegir de galería'**
  String get editProfilePhotoGallery;

  /// No description provided for @editProfilePhotoRemove.
  ///
  /// In es, this message translates to:
  /// **'Quitar foto'**
  String get editProfilePhotoRemove;

  /// No description provided for @editProfilePhotoUploading.
  ///
  /// In es, this message translates to:
  /// **'Subiendo foto…'**
  String get editProfilePhotoUploading;

  /// No description provided for @editProfilePhotoError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo subir la foto'**
  String get editProfilePhotoError;

  /// No description provided for @notificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsTitle;

  /// No description provided for @notificationsSectionAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas de incidentes'**
  String get notificationsSectionAlerts;

  /// No description provided for @notificationsNearby.
  ///
  /// In es, this message translates to:
  /// **'Alertas cercanas'**
  String get notificationsNearby;

  /// No description provided for @notificationsNearbyDesc.
  ///
  /// In es, this message translates to:
  /// **'Avisar cuando hay un incidente cerca de tu ubicación'**
  String get notificationsNearbyDesc;

  /// No description provided for @notificationsRadius.
  ///
  /// In es, this message translates to:
  /// **'Radio de aviso'**
  String get notificationsRadius;

  /// No description provided for @notificationsNewReports.
  ///
  /// In es, this message translates to:
  /// **'Nuevos reportes'**
  String get notificationsNewReports;

  /// No description provided for @notificationsNewReportsDesc.
  ///
  /// In es, this message translates to:
  /// **'Avisar cuando se publica un reporte nuevo en tu zona'**
  String get notificationsNewReportsDesc;

  /// No description provided for @notificationsSectionEmergency.
  ///
  /// In es, this message translates to:
  /// **'Emergencias'**
  String get notificationsSectionEmergency;

  /// No description provided for @notificationsSosContacts.
  ///
  /// In es, this message translates to:
  /// **'SOS de mis contactos'**
  String get notificationsSosContacts;

  /// No description provided for @notificationsSosContactsDesc.
  ///
  /// In es, this message translates to:
  /// **'Avisar si alguno de mis contactos activa una alerta SOS'**
  String get notificationsSosContactsDesc;

  /// No description provided for @notificationsSectionGeneral.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get notificationsSectionGeneral;

  /// No description provided for @notificationsSound.
  ///
  /// In es, this message translates to:
  /// **'Sonido'**
  String get notificationsSound;

  /// No description provided for @notificationsSoundDesc.
  ///
  /// In es, this message translates to:
  /// **'Reproducir sonido al recibir una notificación'**
  String get notificationsSoundDesc;

  /// No description provided for @privacyTitle.
  ///
  /// In es, this message translates to:
  /// **'Privacidad y seguridad'**
  String get privacyTitle;

  /// No description provided for @privacyLocationTitle.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get privacyLocationTitle;

  /// No description provided for @privacyLocationBody.
  ///
  /// In es, this message translates to:
  /// **'Tu ubicación se usa para mostrar incidentes cercanos en el mapa y para adjuntarla automáticamente cuando creás un reporte o activás una alerta SOS. Solo se comparte con tus contactos SOS al activar una alerta, nunca de forma pública.'**
  String get privacyLocationBody;

  /// No description provided for @privacyContactsTitle.
  ///
  /// In es, this message translates to:
  /// **'Contactos SOS'**
  String get privacyContactsTitle;

  /// No description provided for @privacyContactsBody.
  ///
  /// In es, this message translates to:
  /// **'Los contactos que agregués se guardan de forma privada asociados a tu cuenta. Solo se usan para enviarles tu ubicación por WhatsApp o SMS cuando activás el botón SOS. Guardian no accede a tu lista de contactos del teléfono.'**
  String get privacyContactsBody;

  /// No description provided for @privacyReportsTitle.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get privacyReportsTitle;

  /// No description provided for @privacyReportsBody.
  ///
  /// In es, this message translates to:
  /// **'Los reportes que publicás son visibles para otros usuarios de la app con tu nombre de perfil. No se comparte tu email ni tu teléfono en los reportes públicos.'**
  String get privacyReportsBody;

  /// No description provided for @privacyStorageTitle.
  ///
  /// In es, this message translates to:
  /// **'Almacenamiento de datos'**
  String get privacyStorageTitle;

  /// No description provided for @privacyStorageBody.
  ///
  /// In es, this message translates to:
  /// **'Los datos de tu cuenta, reportes y contactos SOS se almacenan en Firebase (Google Cloud). Las fotos de perfil y de los reportes se almacenan en un servicio externo (Cloudinary).'**
  String get privacyStorageBody;

  /// No description provided for @privacyDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar tu cuenta'**
  String get privacyDeleteTitle;

  /// No description provided for @privacyDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'Para solicitar la eliminación de tu cuenta y tus datos, contactá a la cátedra o al administrador del proyecto.'**
  String get privacyDeleteBody;

  /// No description provided for @languageTitle.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageTitle;

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSystemDefault.
  ///
  /// In es, this message translates to:
  /// **'Usar el idioma del dispositivo'**
  String get languageSystemDefault;

  /// No description provided for @themeTitle.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In es, this message translates to:
  /// **'Automático (según el sistema)'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @errorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

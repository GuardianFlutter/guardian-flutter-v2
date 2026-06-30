// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Guardian';

  @override
  String get appTagline => 'Smart and collaborative\ncommunity safety';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Map';

  @override
  String get navReport => 'Report';

  @override
  String get navSos => 'SOS';

  @override
  String get navProfile => 'Profile';

  @override
  String get loginTitle => 'Sign in to continue';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginOr => 'or';

  @override
  String get loginGoogle => 'Continue with Google';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginRegisterLink => 'Sign up';

  @override
  String get loginErrorGeneric => 'Error';

  @override
  String get loginInvalidEmail => 'Enter a valid email';

  @override
  String get loginEmptyPassword => 'Enter your password';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerHaveAccount => 'Already have an account?';

  @override
  String get registerFullName => 'Full name';

  @override
  String get registerNameTooShort => 'Minimum 3 characters';

  @override
  String get registerEmail => 'Email';

  @override
  String get registerInvalidEmail => 'Invalid email';

  @override
  String get registerPhone => 'Phone';

  @override
  String get registerInvalidPhone => 'Invalid phone';

  @override
  String get registerPassword => 'Password';

  @override
  String get registerPasswordTooShort => 'Minimum 6 characters';

  @override
  String get registerConfirmPassword => 'Confirm password';

  @override
  String get registerPasswordMismatch => 'Passwords don\'t match';

  @override
  String get registerStrengthLabel => 'Strength';

  @override
  String get registerStrengthVeryWeak => 'Very weak';

  @override
  String get registerStrengthWeak => 'Weak';

  @override
  String get registerStrengthMedium => 'Medium';

  @override
  String get registerStrengthStrong => 'Strong';

  @override
  String get registerStrengthVeryStrong => 'Very strong';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordBody =>
      'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get forgotPasswordSubmit => 'Send reset email';

  @override
  String get forgotPasswordBackToLogin => 'Back to sign in';

  @override
  String get forgotPasswordSuccess => 'Check your email to reset your password';

  @override
  String get homeWelcome => 'Welcome 👋';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeRecentIncidents => 'Recent incidents';

  @override
  String get homeClearFilter => 'Clear filter';

  @override
  String get homeNoReports => 'No reports yet.\nBe the first to report.';

  @override
  String get homeNoReportsFiltered => 'No incidents of this type yet.';

  @override
  String get homeLastIncident => '⚠ Latest reported incident';

  @override
  String get homeNotificationHint =>
      'Set your preferences in Profile → Notifications';

  @override
  String get homeFilterRobos => 'Theft';

  @override
  String get homeFilterAccidentes => 'Accidents';

  @override
  String get homeFilterZonas => 'Zones';

  @override
  String get homeFilterOtros => 'Other';

  @override
  String get mapTitle => 'Live map';

  @override
  String get mapRealtime => 'Real time';

  @override
  String get mapLegendRobo => 'Theft';

  @override
  String get mapLegendViolencia => 'Violence';

  @override
  String get mapLegendZona => 'Zone';

  @override
  String get mapActive => 'Active';

  @override
  String get mapOngoing => 'Ongoing';

  @override
  String mapProximityAlert(String title, String distance) {
    return '⚠ $title ${distance}m away';
  }

  @override
  String get reportNewTitle => 'New Report';

  @override
  String get reportCategoryLabel => 'Incident category';

  @override
  String get reportTitleField => 'Incident title';

  @override
  String get reportTitleRequired => 'Enter a title';

  @override
  String get reportDescriptionLabel => 'Description';

  @override
  String get reportDescriptionField => 'Describe what happened…';

  @override
  String get reportDescriptionRequired => 'Enter a description';

  @override
  String get reportLocationLabel => 'Location';

  @override
  String get reportLocationDetecting => 'Detecting location...';

  @override
  String get reportLocationDenied => 'Permission denied';

  @override
  String get reportLocationFailed => 'Could not detect location';

  @override
  String get reportGpsButton => 'GPS';

  @override
  String get reportAddPhoto => 'Add photo';

  @override
  String get reportSubmit => 'Submit report';

  @override
  String get reportSuccessMessage => 'Report submitted successfully';

  @override
  String get reportLoginRequired => 'You must sign in';

  @override
  String get reportCatRoboMoto => 'Motorbike theft';

  @override
  String get reportCatAccidente => 'Accident';

  @override
  String get reportCatViolencia => 'Violence';

  @override
  String get reportCatCalleOscura => 'Dark street';

  @override
  String get reportCatZonaPeligrosa => 'Dangerous zone';

  @override
  String get reportCatOtro => 'Other';

  @override
  String get reportDetailTitle => 'Report detail';

  @override
  String get reportDetailNotFound => 'Report not found';

  @override
  String get myReportsTitle => 'My reports';

  @override
  String get myReportsEmpty => 'You haven\'t submitted any reports yet';

  @override
  String get sosTitle => 'Emergency alert';

  @override
  String get sosTapToCancel => 'Tap the button to cancel';

  @override
  String get sosHoldInstruction => 'Hold for 3 seconds';

  @override
  String get sosActivated => '🚨 SOS ALERT ACTIVATED';

  @override
  String get sosCancelled => 'SOS alert cancelled';

  @override
  String get sosSendingMessages => 'Notifying your contacts…';

  @override
  String get sosLocation => 'Location';

  @override
  String get sosGpsActive => 'GPS active';

  @override
  String get sosGpsOn => 'ON';

  @override
  String get sosOnline => 'Online';

  @override
  String get sosContacts => 'Contacts';

  @override
  String get sosInfoTitle => 'What does SOS do?';

  @override
  String get sosInfoLocation => 'Sends your real-time location';

  @override
  String get sosInfoNotify => 'Notifies your contacts via WhatsApp or SMS';

  @override
  String get sosInfoVibration => 'Triggers alert vibration';

  @override
  String get sosInfoReport => 'Automatically creates a report in the app';

  @override
  String get sosStatusActive => 'Status: ACTIVE ALERT';

  @override
  String get sosStatusInactive => 'Status: Inactive';

  @override
  String get sosCall911 => 'Call 911';

  @override
  String get sosManageContacts => 'SOS contacts';

  @override
  String get sosNoContactsTitle => 'You have no SOS contacts';

  @override
  String get sosNoContactsBody =>
      'You won\'t be able to automatically notify anyone. Do you want to add contacts now or continue anyway?';

  @override
  String get sosContinueAnyway => 'Continue anyway';

  @override
  String get sosAddContacts => 'Add contacts';

  @override
  String sosSentToAll(String count, String plural) {
    return 'Message sent to $count contact$plural';
  }

  @override
  String sosSentPartial(String sent, String total) {
    return 'Message sent to $sent of $total contacts';
  }

  @override
  String get sosContactsTitle => 'SOS contacts';

  @override
  String get sosContactsEmpty => 'You have no SOS contacts';

  @override
  String get sosContactsEmptyHint =>
      'Add at least one to receive your location if you activate SOS.';

  @override
  String get sosContactsAddButton => 'Add contact';

  @override
  String get sosContactsAddTitle => 'Add SOS contact';

  @override
  String get sosContactsEditTitle => 'Edit contact';

  @override
  String get sosContactsHint =>
      'This contact will receive your location via WhatsApp or SMS when you activate the SOS button.';

  @override
  String get sosContactsName => 'Name';

  @override
  String get sosContactsNameRequired => 'Required';

  @override
  String get sosContactsPhone => 'Phone (with country code, e.g: +1...)';

  @override
  String get sosContactsPhoneInvalid => 'Invalid phone';

  @override
  String get sosContactsRelation => 'Relationship (mom, dad…)';

  @override
  String get sosContactsSave => 'Save contact';

  @override
  String get sosContactsUpdate => 'Update';

  @override
  String get sosContactsDeleteTitle => 'Delete contact';

  @override
  String sosContactsDeleteConfirm(String name) {
    return 'Delete $name?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileReports => 'Reports';

  @override
  String get profileReputation => 'Reputation';

  @override
  String get profileAlerts => 'Alerts';

  @override
  String get profileMenuReports => 'My reports';

  @override
  String get profileMenuContacts => 'SOS contacts';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuPrivacy => 'Privacy and security';

  @override
  String get profileMenuLanguage => 'Language';

  @override
  String get profileMenuTheme => 'Appearance';

  @override
  String get profileMenuHelp => 'Help and support';

  @override
  String get profileMenuAbout => 'About Guardian';

  @override
  String get profileMenuLogout => 'Log out';

  @override
  String get profileEditButton => 'Edit profile';

  @override
  String get profileLogoutConfirmTitle => 'Log out';

  @override
  String get profileLogoutConfirmBody => 'Are you sure you want to log out?';

  @override
  String get profileNoEmailApp => 'No email app found installed';

  @override
  String get profileAboutBody =>
      'Guardian v1.0.0\n\nCollaborative community safety app. Report incidents, view nearby alerts, and notify your trusted contacts in case of emergency.\n\nAcademic project — Berazategui.';

  @override
  String get close => 'Close';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get editProfileFullName => 'Full name';

  @override
  String get editProfilePhone => 'Phone';

  @override
  String get editProfileEmailReadonly => 'Email (read-only)';

  @override
  String get editProfileSave => 'Save changes';

  @override
  String get editProfileSuccess => 'Profile updated';

  @override
  String get editProfilePhotoTitle => 'Profile photo';

  @override
  String get editProfilePhotoCamera => 'Take photo';

  @override
  String get editProfilePhotoGallery => 'Choose from gallery';

  @override
  String get editProfilePhotoRemove => 'Remove photo';

  @override
  String get editProfilePhotoUploading => 'Uploading photo…';

  @override
  String get editProfilePhotoError => 'Could not upload photo';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsSectionAlerts => 'Incident alerts';

  @override
  String get notificationsNearby => 'Nearby alerts';

  @override
  String get notificationsNearbyDesc =>
      'Notify when there\'s an incident near your location';

  @override
  String get notificationsRadius => 'Alert radius';

  @override
  String get notificationsNewReports => 'New reports';

  @override
  String get notificationsNewReportsDesc =>
      'Notify when a new report is published in your area';

  @override
  String get notificationsSectionEmergency => 'Emergencies';

  @override
  String get notificationsSosContacts => 'SOS from my contacts';

  @override
  String get notificationsSosContactsDesc =>
      'Notify if one of my contacts activates an SOS alert';

  @override
  String get notificationsSectionGeneral => 'General';

  @override
  String get notificationsSound => 'Sound';

  @override
  String get notificationsSoundDesc =>
      'Play a sound when receiving a notification';

  @override
  String get privacyTitle => 'Privacy and security';

  @override
  String get privacyLocationTitle => 'Location';

  @override
  String get privacyLocationBody =>
      'Your location is used to show nearby incidents on the map and to automatically attach it when you create a report or activate an SOS alert. It\'s only shared with your SOS contacts when you activate an alert, never publicly.';

  @override
  String get privacyContactsTitle => 'SOS contacts';

  @override
  String get privacyContactsBody =>
      'The contacts you add are stored privately and linked to your account. They\'re only used to send them your location via WhatsApp or SMS when you activate the SOS button. Guardian does not access your phone\'s contact list.';

  @override
  String get privacyReportsTitle => 'Reports';

  @override
  String get privacyReportsBody =>
      'The reports you publish are visible to other app users along with your profile name. Your email and phone number are not shared in public reports.';

  @override
  String get privacyStorageTitle => 'Data storage';

  @override
  String get privacyStorageBody =>
      'Your account, report, and SOS contact data are stored in Firebase (Google Cloud). Profile and report photos are stored in an external service (Cloudinary).';

  @override
  String get privacyDeleteTitle => 'Delete your account';

  @override
  String get privacyDeleteBody =>
      'To request deletion of your account and data, contact the course staff or project administrator.';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystemDefault => 'Use device language';

  @override
  String get themeTitle => 'Appearance';

  @override
  String get themeSystem => 'Automatic (follow system)';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get retry => 'Retry';
}

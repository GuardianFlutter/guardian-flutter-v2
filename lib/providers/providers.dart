import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import '../data/repositories/sos_contact_repository.dart';
import '../services/messaging_service.dart';

// ═══════════════════════════════════════════════════════════════
// AUTH PROVIDER
// ═══════════════════════════════════════════════════════════════
enum AuthState { idle, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepository();

  AuthState _state = AuthState.idle;
  UserModel? _user;
  String? _errorMessage;

  AuthState get state => _state;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _repo.isLoggedIn;

  Future<bool> loadCurrentUser() async {
    _user = await _repo.getCurrentUser();
    notifyListeners();
    return _user != null;
  }

  Future<bool> login(String email, String password) async {
    _setState(AuthState.loading);
    try {
      _user = await _repo.login(email, password);
      _setState(AuthState.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setState(AuthState.error);
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullName, String phone) async {
    _setState(AuthState.loading);
    try {
      _user = await _repo.register(email, password, fullName, phone);
      _setState(AuthState.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setState(AuthState.error);
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    _setState(AuthState.loading);
    try {
      await _repo.sendPasswordReset(email);
      _setState(AuthState.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setState(AuthState.error);
      return false;
    }
  }

  Future<bool> updateProfile(String fullName, String phone) async {
    final user = _user;
    if (user == null) return false;
    _setState(AuthState.loading);
    try {
      final updated = user.copyWith(fullName: fullName, phone: phone);
      await _repo.updateUser(updated);
      _user = updated;
      _setState(AuthState.success);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setState(AuthState.error);
      return false;
    }
  }

  /// Actualiza solo la foto de perfil (sin pasar por el AuthState de
  /// loading/error general, para no bloquear el resto de la UI de
  /// Editar Perfil mientras se sube la imagen — eso lo maneja la
  /// propia pantalla con su spinner local).
  Future<bool> updatePhotoUrl(String photoUrl) async {
    final user = _user;
    if (user == null) return false;
    try {
      final updated = user.copyWith(photoUrl: photoUrl);
      await _repo.updateUser(updated);
      _user = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    }
  }

  void logout() {
    _repo.logout();
    _user = null;
    _setState(AuthState.idle);
  }

  void clearError() {
    _errorMessage = null;
    _setState(AuthState.idle);
  }

  void _setState(AuthState s) {
    _state = s;
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════════
// REPORT PROVIDER
// ═══════════════════════════════════════════════════════════════
class ReportProvider extends ChangeNotifier {
  final _repo = ReportRepository();
  final _photoRepo = PhotoRepository();

  List<ReportModel> _reports = [];
  List<ReportModel> _userReports = [];
  bool _loading = false;
  String? _error;

  List<ReportModel> get reports => _reports;
  List<ReportModel> get userReports => _userReports;
  bool get loading => _loading;
  String? get error => _error;

  ReportModel? get mostRecentReport =>
      _reports.isNotEmpty ? _reports.first : null;

  List<ReportModel> reportsByType(String type) =>
      _reports.where((r) => r.type == type).toList();

  Future<void> loadReports() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _reports = await _repo.getReports();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserReports(String userId) async {
    try {
      _userReports = await _repo.getReportsByUser(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<ReportModel?> getReportById(String id) async {
    try {
      return await _repo.getReportById(id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> submitReport({
    required String userId,
    required String userName,
    required String title,
    required String description,
    required String type,
    required double latitude,
    required double longitude,
    required String address,
    String? imageFilePath,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final photoUrls = <String>[];
      if (imageFilePath != null) {
        final file = File(imageFilePath);
        final url = await _photoRepo.uploadPhoto(file);
        photoUrls.add(url);
      }
      final report = ReportModel(
        userId: userId,
        title: title,
        description: description,
        type: type,
        latitude: latitude,
        longitude: longitude,
        address: address,
        photoUrls: photoUrls,
        userName: userName,
        createdAt: Timestamp.now(),
      );
      await _repo.createReport(report);
      await loadReports();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// SOS PROVIDER
// ═══════════════════════════════════════════════════════════════
class SosProvider extends ChangeNotifier {
  final _repo = SosRepository();
  final _locationRepo = LocationRepository();
  final _contactRepo = SosContactRepository();
  final _messaging = MessagingService();

  bool _active = false;
  bool _loading = false;
  bool _sendingMessages = false;
  String? _activeAlertId;
  String? _error;

  List<SosContact> _contacts = [];
  List<MessageSendResult> _lastSendResults = [];

  bool get active => _active;
  bool get loading => _loading;
  bool get sendingMessages => _sendingMessages;
  String? get error => _error;
  List<SosContact> get contacts => _contacts;
  List<MessageSendResult> get lastSendResults => _lastSendResults;

  Future<void> loadContacts(String uid) async {
    try {
      _contacts = await _contactRepo.getContacts(uid);
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> addContact(String uid, SosContact contact) async {
    // el modelo SosContact ya incluye ownerUid
    final contactWithOwner = SosContact(
      id: contact.id,
      ownerUid: uid,
      name: contact.name,
      phone: contact.phone,
      relation: contact.relation,
    );
    await _contactRepo.addContact(contactWithOwner);
    await loadContacts(uid);
  }

  Future<void> updateContact(String uid, SosContact contact) async {
    final contactWithOwner = SosContact(
      id: contact.id,
      ownerUid: uid,
      name: contact.name,
      phone: contact.phone,
      relation: contact.relation,
    );
    await _contactRepo.updateContact(contactWithOwner);
    await loadContacts(uid);
  }

  Future<void> deleteContact(String contactId, String uid) async {
    await _contactRepo.deleteContact(contactId);
    await loadContacts(uid);
  }

  Future<bool> activateSos({
    required String userId,
    required String userName,
    String userPhone = '',
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      double lat = 0, lon = 0;
      String address = 'Ubicación desconocida';
      try {
        final pos = await _locationRepo.getCurrentLocation();
        lat = pos.latitude;
        lon = pos.longitude;
        address = await _locationRepo.getAddressFromLocation(lat, lon);
      } catch (_) {}

      _activeAlertId = await _repo.activateSos(
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        latitude: lat,
        longitude: lon,
        address: address,
      );
      _active = true;
      _loading = false;
      notifyListeners();

      await _notifyContacts(
        userId: userId,
        userName: userName,
        latitude: lat,
        longitude: lon,
        address: address,
      );

      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _notifyContacts({
    required String userId,
    required String userName,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    if (_contacts.isEmpty) {
      await loadContacts(userId);
    }
    if (_contacts.isEmpty) return;

    _sendingMessages = true;
    notifyListeners();

    final message = _messaging.buildSosMessage(
      userName: userName,
      latitude: latitude,
      longitude: longitude,
      address: address,
    );

    _lastSendResults = await _messaging.sendSosToAll(
      contacts: _contacts,
      message: message,
    );

    _sendingMessages = false;
    notifyListeners();
  }

  Future<void> cancelSos() async {
    final id = _activeAlertId;
    if (id != null) {
      try { await _repo.cancelSos(id); } catch (_) {}
    }
    _active = false;
    _activeAlertId = null;
    _lastSendResults = [];
    notifyListeners();
  }
}

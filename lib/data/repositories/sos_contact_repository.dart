import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SosContact {
  final String id;
  final String ownerUid;
  final String name;
  final String email;
  final String phone;
  final String relation;

  const SosContact({
    required this.id,
    required this.ownerUid,
    required this.name,
    required this.email,
    required this.phone,
    required this.relation,
  });

  factory SosContact.fromMap(String id, Map<String, dynamic> m) => SosContact(
        id: id,
        ownerUid: m['ownerUid'] as String? ?? '',
        name: m['name'] as String? ?? '',
        email: m['email'] as String? ?? '',
        phone: m['phone'] as String? ?? '',
        relation: m['relation'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'ownerUid': ownerUid,
        'name': name,
        'email': email,
        'phone': phone,
        'relation': relation,
      };

  String get cleanPhone => phone.replaceAll(RegExp(r'[^0-9+]'), '');
}

// ═══════════════════════════════════════════════════════════════
// SOS CONTACT REPOSITORY (colección plana)
// ═══════════════════════════════════════════════════════════════
class SosContactRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference get _col => _db.collection('sos_contacts');

  Future<List<SosContact>> getContacts(String uid) async {
    final snap = await _col.where('ownerUid', isEqualTo: uid).get();
    return snap.docs
        .map((d) => SosContact.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }

  Stream<List<SosContact>> watchContacts(String uid) {
    return _col.where('ownerUid', isEqualTo: uid).snapshots().map((snap) =>
        snap.docs
            .map((d) =>
                SosContact.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addContact(SosContact contact) async {
    await _col.add(contact.toMap());
  }

  Future<void> updateContact(SosContact contact) async {
    await _col.doc(contact.id).update(contact.toMap());
  }

  Future<void> deleteContact(String contactId) async {
    await _col.doc(contactId).delete();
  }
}

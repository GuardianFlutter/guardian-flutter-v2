import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../auth/splash_screen.dart' show GradientButton;

class SosContact {
  final String id, name, phone, relation;
  const SosContact({required this.id, required this.name,
      required this.phone, required this.relation});

  factory SosContact.fromMap(String id, Map<String, dynamic> m) => SosContact(
    id: id,
    name: m['name'] as String? ?? '',
    phone: m['phone'] as String? ?? '',
    relation: m['relation'] as String? ?? '',
  );

  Map<String, dynamic> toMap() => {'name': name, 'phone': phone, 'relation': relation};
}

class SosContactsScreen extends StatefulWidget {
  const SosContactsScreen({super.key});

  @override
  State<SosContactsScreen> createState() => _SosContactsScreenState();
}

class _SosContactsScreenState extends State<SosContactsScreen> {
  late CollectionReference _col;
  bool _loading = true;
  List<SosContact> _contacts = [];

  @override
  void initState() {
    super.initState();
    final uid = context.read<AuthProvider>().user?.uid ?? 'anon';
    _col = FirebaseFirestore.instance.collection('sos_contacts').doc(uid).collection('contacts');
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final snap = await _col.get();
    _contacts = snap.docs.map((d) => SosContact.fromMap(d.id, d.data() as Map<String, dynamic>)).toList();
    setState(() => _loading = false);
  }

  Future<void> _delete(String id) async {
    await _col.doc(id).delete();
    await _load();
  }

  void _showForm([SosContact? contact]) {
    final nameCtrl   = TextEditingController(text: contact?.name ?? '');
    final phoneCtrl  = TextEditingController(text: contact?.phone ?? '');
    final relCtrl    = TextEditingController(text: contact?.relation ?? '');
    final formKey    = GlobalKey<FormState>();
    bool saving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20,
            20 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact == null ? 'Agregar contacto SOS' : 'Editar contacto',
                  style: const TextStyle(color: AppColors.textPrimary,
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameCtrl,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (v) => (v == null || v.length < 8) ? 'Teléfono inválido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: relCtrl,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                decoration: const InputDecoration(labelText: 'Relación (mamá, papá…)'),
              ),
              const SizedBox(height: 20),
              StatefulBuilder(builder: (ctx2, setInner) => GradientButton(
                label: contact == null ? 'Guardar contacto' : 'Actualizar',
                loading: saving,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  setInner(() => saving = true);
                  final data = {
                    'name': nameCtrl.text.trim(),
                    'phone': phoneCtrl.text.trim(),
                    'relation': relCtrl.text.trim(),
                  };
                  if (contact == null) {
                    await _col.add(data);
                  } else {
                    await _col.doc(contact.id).update(data);
                  }
                  if (mounted) { Navigator.pop(ctx); await _load(); }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos SOS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _showForm(),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _contacts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_outline, color: AppColors.borderColor, size: 56),
                      const SizedBox(height: 12),
                      const Text('No tenés contactos SOS',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showForm(),
                        child: const Text('Agregar contacto'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _contacts.length,
                  itemBuilder: (_, i) {
                    final c = _contacts[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderColor, width: 0.5),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.catSelectedBg,
                          child: Text(
                            c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(c.name,
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                        subtitle: Text(
                          '${c.phone}${c.relation.isNotEmpty ? ' · ${c.relation}' : ''}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.textSecondary, size: 18),
                              onPressed: () => _showForm(c),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.error, size: 18),
                              onPressed: () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: AppColors.cardBg,
                                    title: const Text('Eliminar contacto',
                                        style: TextStyle(color: AppColors.textPrimary)),
                                    content: Text('¿Eliminar a ${c.name}?',
                                        style: const TextStyle(color: AppColors.textSecondary)),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false),
                                          child: const Text('Cancelar')),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Eliminar',
                                            style: TextStyle(color: AppColors.error)),
                                      ),
                                    ],
                                  ),
                                );
                                if (ok == true) _delete(c.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

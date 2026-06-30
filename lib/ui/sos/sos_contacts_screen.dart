import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors_x.dart';
import '../../data/repositories/sos_contact_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';
import '../auth/splash_screen.dart' show GradientButton;

class SosContactsScreen extends StatefulWidget {
  const SosContactsScreen({super.key});

  @override
  State<SosContactsScreen> createState() => _SosContactsScreenState();
}

class _SosContactsScreenState extends State<SosContactsScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String? get _uid => context.read<AuthProvider>().user?.uid;

  Future<void> _load() async {
    final uid = _uid;
    if (uid == null) { setState(() => _loading = false); return; }
    setState(() => _loading = true);
    await context.read<SosProvider>().loadContacts(uid);
    setState(() => _loading = false);
  }

  Future<void> _delete(String id) async {
    final uid = _uid;
    if (uid == null) return;
    await context.read<SosProvider>().deleteContact(uid, id);
  }

  void _showForm([SosContact? contact]) {
    final t = AppLocalizations.of(context)!;
    final nameCtrl   = TextEditingController(text: contact?.name ?? '');
    final phoneCtrl  = TextEditingController(text: contact?.phone ?? '');
    final relCtrl    = TextEditingController(text: contact?.relation ?? '');
    final formKey    = GlobalKey<FormState>();
    bool saving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.cardBg,
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
              Text(contact == null ? t.sosContactsAddTitle : t.sosContactsEditTitle,
                  style: TextStyle(color: context.colors.textPrimary,
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(t.sosContactsHint,
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameCtrl,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                decoration: InputDecoration(labelText: t.sosContactsName),
                validator: (v) => (v == null || v.isEmpty) ? t.sosContactsNameRequired : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                decoration: InputDecoration(labelText: t.sosContactsPhone),
                validator: (v) => (v == null || v.length < 8) ? t.sosContactsPhoneInvalid : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: relCtrl,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                decoration: InputDecoration(labelText: t.sosContactsRelation),
              ),
              const SizedBox(height: 20),
              StatefulBuilder(builder: (ctx2, setInner) => GradientButton(
                label: contact == null ? t.sosContactsSave : t.sosContactsUpdate,
                loading: saving,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  final uid = _uid;
                  if (uid == null) return;
                  setInner(() => saving = true);
                  final sos = context.read<SosProvider>();
                  if (contact == null) {
                    await sos.addContact(uid, SosContact(
                      id: '',
                      ownerUid: uid,
                      name: nameCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      relation: relCtrl.text.trim(),
                    ));
                  } else {
                    await sos.updateContact(uid, SosContact(
                      id: contact.id,
                      ownerUid: uid,
                      name: nameCtrl.text.trim(),
                      phone: phoneCtrl.text.trim(),
                      relation: relCtrl.text.trim(),
                    ));
                  }
                  if (mounted) Navigator.pop(ctx);
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
    final t = AppLocalizations.of(context)!;
    final contacts = context.watch<SosProvider>().contacts;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.sosContactsTitle),
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
          : contacts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, color: context.colors.borderColor, size: 56),
                      const SizedBox(height: 12),
                      Text(t.sosContactsEmpty,
                          style: TextStyle(color: context.colors.textSecondary, fontSize: 14)),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          t.sosContactsEmptyHint,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.colors.textSecondary, fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _showForm(),
                        child: Text(t.sosContactsAddButton),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: contacts.length,
                  itemBuilder: (_, i) {
                    final c = contacts[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: context.colors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: context.colors.borderColor, width: 0.5),
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
                            style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
                        subtitle: Text(
                          '${c.phone}${c.relation.isNotEmpty ? ' · ${c.relation}' : ''}',
                          style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: context.colors.textSecondary, size: 18),
                              onPressed: () => _showForm(c),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.error, size: 18),
                              onPressed: () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: context.colors.cardBg,
                                    title: Text(t.sosContactsDeleteTitle,
                                        style: TextStyle(color: context.colors.textPrimary)),
                                    content: Text(t.sosContactsDeleteConfirm(c.name),
                                        style: TextStyle(color: context.colors.textSecondary)),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false),
                                          child: Text(t.cancel)),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text(t.delete, style: const TextStyle(color: AppColors.error)),
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

// ═══════════════════════════════════════════════════════════════
// REGISTER SCREEN
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../main_screen.dart';
import 'splash_screen.dart' show GradientButton;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey     = GlobalKey<FormState>();
  bool _obscure1 = true, _obscure2 = true;
  int _strength = 0;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  void _updateStrength(String pw) {
    int s = 0;
    if (pw.length >= 6) s++;
    if (pw.length >= 10) s++;
    if (pw.contains(RegExp(r'[A-Z]'))) s++;
    if (pw.contains(RegExp(r'[a-z]'))) s++;
    if (pw.contains(RegExp(r'[0-9]'))) s++;
    if (pw.contains(RegExp(r'[^a-zA-Z0-9]'))) s++;
    setState(() => _strength = s);
  }

  Color get _strengthColor {
    if (_strength <= 1) return AppColors.error;
    if (_strength <= 2) return AppColors.secondary;
    if (_strength <= 3) return AppColors.warn;
    return AppColors.success;
  }

  String get _strengthLabel {
    if (_strength <= 1) return 'Muy débil';
    if (_strength <= 2) return 'Débil';
    if (_strength <= 3) return 'Media';
    if (_strength <= 4) return 'Fuerte';
    return 'Muy fuerte';
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      _emailCtrl.text.trim(),
      _passCtrl.text,
      _nameCtrl.text.trim(),
      _phoneCtrl.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const MainScreen()), (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Error'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Crear cuenta',
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('¿Ya tenés cuenta?',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Nombre completo'),
                  validator: (v) => (v == null || v.trim().length < 3) ? 'Mínimo 3 caracteres' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Correo electrónico'),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Email inválido' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (v) => (v == null || v.length < 8) ? 'Teléfono inválido' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure1,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  onChanged: _updateStrength,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textSecondary, size: 20),
                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
                ),
                if (_passCtrl.text.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('Fortaleza ', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: _strength / 6,
                            backgroundColor: AppColors.borderColor,
                            valueColor: AlwaysStoppedAnimation(_strengthColor),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(_strengthLabel,
                          style: TextStyle(color: _strengthColor, fontSize: 10)),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: _obscure2,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textSecondary, size: 20),
                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                    ),
                  ),
                  validator: (v) => v != _passCtrl.text ? 'Las contraseñas no coinciden' : null,
                ),
                const SizedBox(height: 20),
                GradientButton(
                  label: 'Crear cuenta',
                  loading: auth.state == AuthState.loading,
                  onPressed: _register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// FORGOT PASSWORD SCREEN
// ═══════════════════════════════════════════════════════════════
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey   = GlobalKey<FormState>();

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.sendPasswordReset(_emailCtrl.text.trim());
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revisá tu correo para restablecer la contraseña'),
            backgroundColor: AppColors.success),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Error'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 56),
                const Icon(Icons.lock_reset, color: AppColors.primary, size: 56),
                const SizedBox(height: 16),
                const Text('Recuperar contraseña',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                  'Ingresá tu correo y te enviaremos un enlace para restablecer tu contraseña.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Correo electrónico'),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Email inválido' : null,
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: 'Enviar correo de recuperación',
                  loading: auth.state == AuthState.loading,
                  onPressed: _send,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Volver al inicio de sesión',
                      style: TextStyle(color: AppColors.primary, fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

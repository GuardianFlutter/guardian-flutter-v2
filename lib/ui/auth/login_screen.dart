import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/providers.dart';
import '../main_screen.dart';
import 'splash_screen.dart' show GradientButton;
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _GuardianShield extends StatelessWidget {
  final double size;
  const _GuardianShield({Key? key, this.size = 36}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Icon(Icons.security, color: AppColors.primary, size: size),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _formKey   = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
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
                const SizedBox(height: 40),
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(children: [
                              TextSpan(text: 'Guard', style: TextStyle(color: AppColors.primary,      fontSize: 20, fontWeight: FontWeight.bold)),
                              TextSpan(text: 'ian',   style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                            ]),
                          ),
                          const SizedBox(height: 2),
                          const Text('Iniciá sesión para continuar',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ),
                    _GuardianShield(size: 36),
                  ],
                ),
                const SizedBox(height: 40),
                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: const InputDecoration(labelText: 'Correo electrónico'),
                  validator: (v) {
                    if (v == null || !v.contains('@')) return 'Ingresá un email válido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textSecondary, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Ingresá tu contraseña' : null,
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                    child: const Text('¿Olvidaste tu contraseña?',
                        style: TextStyle(color: AppColors.primary, fontSize: 11)),
                  ),
                ),
                const SizedBox(height: 20),
                GradientButton(
                  label: 'Iniciar sesión',
                  loading: auth.state == AuthState.loading,
                  onPressed: _login,
                ),
                const SizedBox(height: 16),
                // Divider "o"
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.borderColor, thickness: 0.5)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('o', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ),
                    const Expanded(child: Divider(color: AppColors.borderColor, thickness: 0.5)),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Continuar con Google',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text.rich(
                      TextSpan(children: [
                        TextSpan(text: '¿No tenés cuenta? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        TextSpan(text: 'Registrate',         style: TextStyle(color: AppColors.primary, fontSize: 13)),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

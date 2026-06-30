import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors_x.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';
import '../main_screen.dart';
import 'splash_screen.dart' show GradientButton, GuardianShield;
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
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
    final t = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? t.loginErrorGeneric), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                          Text(t.loginTitle,
                              style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ),
                    const GuardianShield(size: 36),
                  ],
                ),
                const SizedBox(height: 40),
                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                  decoration: InputDecoration(labelText: t.loginEmail),
                  validator: (v) {
                    if (v == null || !v.contains('@')) return t.loginInvalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    labelText: t.loginPassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                          color: context.colors.textSecondary, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? t.loginEmptyPassword : null,
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                    child: Text(t.loginForgotPassword,
                        style: const TextStyle(color: AppColors.primary, fontSize: 11)),
                  ),
                ),
                const SizedBox(height: 20),
                GradientButton(
                  label: t.loginButton,
                  loading: auth.state == AuthState.loading,
                  onPressed: _login,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider(color: context.colors.borderColor, thickness: 0.5)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(t.loginOr, style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
                    ),
                    Expanded(child: Divider(color: context.colors.borderColor, thickness: 0.5)),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {},
                  child: Text(t.loginGoogle,
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: t.loginNoAccount, style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                        TextSpan(text: t.loginRegisterLink, style: const TextStyle(color: AppColors.primary, fontSize: 13)),
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

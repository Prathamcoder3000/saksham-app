import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'forgot_password.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';
import 'caretaker_dashboard.dart';
import 'family_dashboard.dart';
import 'role_selection.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ── Fix: password visibility state ──
  bool _obscurePassword = true;

  // RFC-5322 simplified email regex
  static const String _emailRegex =
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        final backendRole = authProvider.user?.role ?? '';
        final selectedRole = widget.role.toLowerCase();

        // Inform user if they picked a different entry point
        if (backendRole.toLowerCase() != selectedRole) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logging in as $backendRole...'),
              backgroundColor: Colors.blueAccent,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        Widget nextScreen;
        switch (backendRole) {
          case 'Admin':
            nextScreen = const DashboardScreen();
            break;
          case 'Caretaker':
            nextScreen = const CaretakerDashboard();
            break;
          case 'Family':
            nextScreen = const FamilyDashboard();
            break;
          default:
            nextScreen = const RoleSelectionScreen();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.invalidCredentials),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ─────────────────────────────────────────────
          // 🔵 GRADIENT HEADER
          // ─────────────────────────────────────────────
          Container(
            height: 320,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.spa, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Saksham',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.login,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // ─────────────────────────────────────────────
          // ⚪ FORM SECTION
          // ─────────────────────────────────────────────
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF6FAFE),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Email ──
                      Text(AppLocalizations.of(context)!.email),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.emailRequired;
                          }
                          if (!RegExp(_emailRegex).hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'name@example.com',
                          prefixIcon: const Icon(Icons.mail),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Password ──
                      Text(AppLocalizations.of(context)!.password),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        // Fix: driven by state variable, not hardcoded true
                        obscureText: _obscurePassword,
                        validator: (value) => value == null || value.isEmpty
                            ? AppLocalizations.of(context)!.passwordRequired
                            : null,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock),
                          // Fix: functional visibility toggle
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.forgotPassword,
                            style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // ── LOGIN BUTTON ──
                      Consumer<AuthProvider>(
                        builder: (context, auth, child) {
                          return GestureDetector(
                            onTap: auth.isLoading ? null : _login,
                            child: Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: auth.isLoading
                                      ? [Colors.grey, Colors.grey]
                                      : [const Color(0xFF2563EB), const Color(0xFF14B8A6)],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: auth.isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.login,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.arrow_forward, color: Colors.white),
                                        ],
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 25),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(AppLocalizations.of(context)!.orContinueWith),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Social Buttons (visual only — no social auth backend)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _socialBtn('Google'),
                          _socialBtn('Facebook'),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // ── Fix: clickable "Create Account" ──
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.dontHaveAccount,
                            style: const TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!.createAccount,
                                style: const TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.bold,
                                ),
                                // Fix: TapGestureRecognizer routes to RegisterScreen
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RegisterScreen(role: widget.role),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(AppLocalizations.of(context)!.help),
                          Text(AppLocalizations.of(context)!.privacy),
                          Text(AppLocalizations.of(context)!.terms),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialBtn(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }
}
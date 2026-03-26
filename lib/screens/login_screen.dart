import 'package:flutter/material.dart';
import 'role_selection.dart';
import 'dashboard_screen.dart';
import 'caretaker_dashboard.dart';
import 'family_dashboard.dart';
import 'loading_screen.dart';
import 'forgot_password.dart';
class LoginScreen extends StatelessWidget {
final String role;

const LoginScreen({super.key, required this.role});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          // 🔵 GRADIENT HEADER
          Container(
            height: 320,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 60, 24, 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.spa, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Saksham",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Welcome back to your digital sanctuary.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // ⚪ FORM SECTION
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFFF6FAFE),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Email
                  Text("Email Address"),
                  SizedBox(height: 10),
                  _inputField(
                    icon: Icons.mail,
                    hint: "name@example.com",
                  ),

                  SizedBox(height: 20),

                  // Password
                  Text("Password"),
                  SizedBox(height: 10),
                  _inputField(
                    icon: Icons.lock,
                    hint: "••••••••",
                    isPassword: true,
                  ),

                  SizedBox(height: 10),

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
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                  SizedBox(height: 30),

                  // 🔵 LOGIN BUTTON
                  GestureDetector(
                    onTap: () {
                        if (role == "admin") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoadingScreen(role: role)),
                            );
                        } else if (role == "caretaker") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoadingScreen(role: role)),
                            );
                        } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoadingScreen(role: role)),
                            );
                        }
                    },
                    child: Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF14B8A6)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                            BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                            )
                        ],
                        ),
                        child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text(
                                "Login",
                                style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                        ),
                        ),
                    ),
                    ),

                  SizedBox(height: 25),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("OR CONTINUE WITH"),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _socialBtn("Google"),
                      _socialBtn("Facebook"),
                    ],
                  ),

                  Spacer(),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                            text: "Create Account",
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Help"),
                      Text("Privacy"),
                      Text("Terms"),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _inputField({required IconData icon, required String hint, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword ? Icon(Icons.visibility) : null,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _socialBtn(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }
}
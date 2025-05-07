import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.find<AuthController>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Futuristic background with abstract curves
          Positioned.fill(child: CustomPaint(painter: _BackgroundPainter())),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 80, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildRoundedTextField(
                    controller: controller.usernameController,
                    hintText: "Username",
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 20),
                  _buildRoundedTextField(
                    controller: controller.passwordController,
                    hintText: "Password",
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  Obx(() {
                    return controller.isLoading.value
                        ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white70),
                        )
                        : ElevatedButton(
                          onPressed: controller.login,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.cyanAccent.shade700,
                            padding: EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 12,
                            shadowColor: Colors.black54,
                          ),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withValues(alpha: 0.2),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}

/// Custom painter for abstract soft blue curves
class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Base gradient
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = LinearGradient(
      colors: [Color(0xFF2196F3), Color(0xFF81D4FA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Abstract curves
    Path path =
        Path()
          ..moveTo(0, size.height * 0.4)
          ..quadraticBezierTo(
            size.width * 0.25,
            size.height * 0.35,
            size.width * 0.5,
            size.height * 0.5,
          )
          ..quadraticBezierTo(
            size.width * 0.75,
            size.height * 0.65,
            size.width,
            size.height * 0.6,
          )
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
          ..close();
    paint.shader = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0.2),
        Colors.white.withValues(alpha: 0.05),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(rect);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

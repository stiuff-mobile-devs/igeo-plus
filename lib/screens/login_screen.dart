import 'package:flutter/material.dart';
import 'package:igeo/utils/auth_utils.dart';
import 'package:sign_button/sign_button.dart';

import '../utils/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthUtils auth = AuthUtils();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF004D40),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map_outlined,
              size: 90,
              color: Color(0xFF004D40),
            ),

            const SizedBox(height: 32),

            const Text(
              'iGeo',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 44),
            const Divider(indent: 60, endIndent: 60),
            const SizedBox(height: 12),

            SignInButton(
              buttonType: ButtonType.googleDark,
              btnText: "Entrar com o Google",
              onPressed: () async {
                bool success = await auth.signInWithGoogle();
                if (success) {
                  Navigator.pushReplacementNamed(context, AppRoutes.HOME2);
                }
              },
            ),

            const SizedBox(height: 40),


          ],
        ),
      ),
    );
  }
}

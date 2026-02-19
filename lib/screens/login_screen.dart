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
        title: const Text('Entrar'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 90,
              color: Theme.of(context).primaryColor,
            ),

            const SizedBox(height: 32),

            const Text(
              'iGeo',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Aplicativo de georreferenciamento para visualização e organização de pontos e projetos geográficos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 28),

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

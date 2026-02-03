import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o iGeo'),
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

            const Text(
              'Versão 1.0.0',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Saiba Mais',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

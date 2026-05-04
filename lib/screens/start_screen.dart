import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/igeo_appbar.dart';
import '../components/text.dart';
import '../utils/auth_utils.dart';
import '../utils/db_utils.dart';
import '../utils/routes.dart';
import 'package:photo_manager/photo_manager.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final AuthUtils auth = AuthUtils();
  bool _isLoading = true;
  bool accept = false;
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final PermissionState status = await PhotoManager.requestPermissionExtend();
    if (!mounted) return;

    if (!status.isAuth) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sem permissão'),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  _checkSignInStatus() {
    loggedIn = auth.getFirebaseAuthUser() != null;
  }

  _logOut() async {
    await auth.signOut();
    setState(() {
      loggedIn = false;
    });
  }

  submitForm() async {
    //print(formData);
    final dataFromAccept = await DbUtils.getData("accepts");
    print(dataFromAccept);

    if (dataFromAccept[0]['accept'] == 'false') {
      Widget alert = AlertDialog(
        title: const Row(
          children: [
            const Icon(
              Icons.warning_amber_outlined,
              color: Colors.amber,
              size: 12,
            ),
            const Expanded(
              child: Text(
                " Termos de Uso/Terms of Use",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 189, 39, 39),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            signupText,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // setState(() {
              //   accept = true;
              // });
              Navigator.of(context).pop();
              await DbUtils.updateAccept();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You have accepted the terms of use'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text("Agree/aceito"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
              setState(() {
                //accept = false;
              });

              return;
            },
            child: const Text("Not agree/não aceito"),
          ),
        ],
      );
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => alert,
      );

      // if (accept) {
      //   await DbUtil.updateAccept();

      //   Navigator.of(context).pushNamed(
      //     AppRoutes.HOME2,
      //   );
      //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Você aceitou o termo de responsabilidade'),
      //       duration: Duration(seconds: 2),
      //     ),
      //   );
      // } else {
      //   return;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IgeoAppbar.getBarWithoutBack(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/logo.png",
                    height: 300,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        await submitForm();
                        if (!loggedIn) {
                          Navigator.pushNamed(context, AppRoutes.LOGIN);
                        } else {
                          Navigator.pushReplacementNamed(context, AppRoutes.HOME2);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        'Enter',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  if (loggedIn) ... [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _logOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextButton(
                      onPressed: () async {
                        final confirm = await _showDeleteDialog(context);

                        if (confirm == true) {
                          await deleteAccount();
                        }
                      },
                      child: const Text(
                        'Delete account',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
    );
  }

  Future<void> deleteAccount() async {
    final AuthUtils auth = AuthUtils();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;
    final providerId = user.providerData.first.providerId;

    try {
      if (providerId == 'google.com') {
        await auth.signInWithGoogle();
      } else if (providerId == 'apple.com') {
        final appleProvider = AppleAuthProvider();
        await user.reauthenticateWithProvider(appleProvider);
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .delete();

      await user.delete();
      await _logOut();
    } catch (e) {
      print("Erro ao excluir conta: $e");
      rethrow;
    }
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir conta'),
          content: const Text(
            'Tem certeza que deseja excluir sua conta? Essa ação é irreversível.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

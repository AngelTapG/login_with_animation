import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required String title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  StateMachineController? controller;
  SMIBool? isChecking;
  SMIBool? isHandsUp;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;

  void _onRiveInit(Artboard artboard) {
    controller = StateMachineController.fromArtboard(
      artboard,
      "Login Machine",
    );
    if (controller == null) return;

    artboard.addController(controller!);

    isChecking = controller!.findInput<bool>("isChecking") as SMIBool?;
    isHandsUp = controller!.findInput<bool>("isHandsUp") as SMIBool?;
    trigSuccess = controller!.findInput<bool>("trigSuccess") as SMITrigger?;
    trigFail = controller!.findInput<bool>("trigFail") as SMITrigger?;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  "assets/animated_login_character.riv",
                  stateMachines: ["Login Machine"],
                  onInit: _onRiveInit,
                ),
              ),

              const SizedBox(height: 10),

              // Campo email
              TextField(
                onChanged: (value) {
                  // Activa "modo chismoso"
                  isChecking?.value = true;
                  // Baja manos si estaba tapándose
                  isHandsUp?.value = false;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: size.width,
                child: const Text(
                  "Forgot your password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),

              const SizedBox(height: 10),

              // Campo contraseña
              TextField(
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                onTap: () {
                  // Se tapa los ojos al escribir contraseña
                  isHandsUp?.value = true;
                },
                onEditingComplete: () {
                  // Baja las manos al terminar
                  isHandsUp?.value = false;
                },
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Botón login
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  final success = true; // Simulación
                  if (success) {
                    trigSuccess?.fire();
                  } else {
                    trigFail?.fire();
                  }
                },
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t you have an account? "),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
// 3.1 Importar librerIa para Timer
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variable para controlar la visibilidad de la contraseña
  bool _obscureText = true;

  //Logica animaciones
  StateMachineController? controller;
  //State machine inputs
  SMIBool? isChecking; // activa el modo "chismoso"
  SMIBool? isHandsUp; // se tapa los ojos
  SMITrigger? trigSuccess; // se emociona
  SMITrigger? trigFail; // se pone sad
  //2.1 Variable para recorrido de mirada
  SMINumber? numLook; // se pone sad

  // 1) FocusNode
  final emailFocus = FocusNode();
  final passFocus = FocusNode();

  //3.2 Timer para detener la mirada al dejar de teclear
  Timer? _typingDebounce;

  // 2) Listeners (Oyentes)
  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        //manos abajo en email
        isHandsUp?.change(false);
        //2.2 mirada neutral al enfocar email
        numLook?.value = 50.0;
        isHandsUp?.change(false);
      }
    });
    passFocus.addListener(() {
      isHandsUp?.change(passFocus.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Para obtener el tamaño del dispositivo
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            SizedBox(
              width: size.width,
              height: 200,
              child: RiveAnimation.asset(
                'assets/animated_login_character.riv',
                stateMachines: ["Login Machine"],
                //Al iniciar la animacion
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(
                      artboard, 'Login Machine');
                  if (controller == null) return;
                  artboard.addController(controller!);
                  //asignar los inputs
                  isChecking = controller!.findSMI('isChecking');
                  isHandsUp = controller!.findSMI('isHandsUp');
                  trigSuccess = controller!.findSMI('trigSuccess');
                  trigFail = controller!.findSMI('trigFail');
                  //2.3 Enlazar variable con la animación
                  numLook = controller!.findSMI('numLook');
                }, // clamp
              ),
            ),
            // espacio entre el oso y el email
            const SizedBox(height: 10),
            // campo de texto de email
            TextField(
              //asignar focusnode
              focusNode: emailFocus,

              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                // Lógica para manejar el cambio en el campo de email
                if (isHandsUp != null) {
                  //isHandsUp!.change(false)
                  isChecking!.change(true);

                  //Ajuste de límites de 0 a 100
                  //80 es una medida de calibracion
                  final look = (value.length / 80.0 * 100.0).clamp(
                    0.0,
                    100.0,
                  );
                  numLook?.value = look;

                  //3.3
                  _typingDebounce
                      ?.cancel(); // Cancela cualquier timer existente
                  _typingDebounce = Timer(const Duration(seconds: 3), () {
                    if (!mounted) {
                      return; //si la pantalla se cierra
                    }
                    //mirada neutra
                    isChecking?.change(false);
                  });
                }
                //checa modo chismoso
                if (isChecking == null) return;
                {
                  isChecking!.change(true);
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Email',
                hintText: 'Ingresa tu email',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              focusNode: passFocus,
              obscureText: _obscureText,
              onChanged: (value) {
                // Lógica para manejar el cambio en el campo de email
                if (isHandsUp != null) {
                  // isChecking?.change(false);
                }
                if (isChecking == null) return;
                {
                  isChecking?.change(true);
                }
              }, // Usamos la variable para controlar la visibilidad
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isChecking != null) {
                        isHandsUp!.change(true);
                      }

                      if (isHandsUp == null) return;
                      {
                        isHandsUp!.change(true);
                      }

                      _obscureText =
                          !_obscureText; // Cambiamos el estado al presionar
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Contraseña',
                hintText: 'Ingresa tu contraseña',
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: size.width,
              child: const Text(
                '¿Olvidaste tu contraseña?',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: size.width,
              height: 50,
              child: MaterialButton(
                color: Colors.teal[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                onPressed: () {
                  //TODO:
                },
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes una cuenta?'),
                  TextButton(
                    onPressed: () {
                      //TODO:
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(5),
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                    ),
                    child: const Text(
                      'Regístrate',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}

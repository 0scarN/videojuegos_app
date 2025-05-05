import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_form_provider.dart';
import '../services/auth_service.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Inicio de sesión', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 30),

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
                child: const Text('¿No tienes cuenta? ¡Regístrate aquí!'),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final authService = Provider.of<AuthService>(context);

    return Form(
      key: loginForm.formKey,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'correo@ejemplo.com',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.email_outlined,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : 'Correo no válido';
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*******',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6) ? null : 'Debe tener 6 caracteres';
            },
          ),
          const SizedBox(height: 20),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            color: Colors.deepPurple,
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!loginForm.isValidForm()) return;

                    loginForm.isLoading = true;

                    print('📨 Iniciando login...');

                    final errorMessage = await authService.login(
                      loginForm.email,
                      loginForm.password,
                    );

                    print('📬 Resultado: $errorMessage');

                    if (errorMessage == null) {
                      print('✅ Login exitoso. Navegando a list...');
                      Navigator.pushReplacementNamed(context, 'list');
                    } else {
                      print('❌ Login fallido: $errorMessage');
                      loginForm.isLoading = false;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Error'),
                          content: Text(errorMessage),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading ? 'Espere...' : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

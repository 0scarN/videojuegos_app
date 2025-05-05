import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/register_form_provider.dart';
import '../services/auth_service.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                    Text('Crear cuenta', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => RegisterFormProvider(),
                      child: _RegisterForm(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);
    final authService = Provider.of<AuthService>(context);

    return Form(
      key: registerForm.formKey,
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
            onChanged: (value) => registerForm.email = value,
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
            onChanged: (value) => registerForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6) ? null : 'Debe tener 6 caracteres';
            },
          ),
          const SizedBox(height: 20),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            color: Colors.deepPurple,
            onPressed: registerForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!registerForm.isValidForm()) return;

                    registerForm.isLoading = true;

                    final errorMessage = await authService.register(
                      registerForm.email,
                      registerForm.password,
                    );

                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed(context, 'check');
                    } else {
                      registerForm.isLoading = false;
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
                registerForm.isLoading ? 'Espere...' : 'Registrarse',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

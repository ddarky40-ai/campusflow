import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _institutionController = TextEditingController();
  final _programController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _institutionController.dispose();
    _programController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(authProvider.notifier).register(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            institution: _institutionController.text.trim(),
            program: _programController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) context.go('/taches');
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Créer mon compte',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom complet',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) => value == null ||
                            value.trim().isEmpty
                        ? 'Le nom complet est obligatoire'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Adresse e-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'L’adresse e-mail est obligatoire';
                      }
                      if (!value.contains('@')) {
                        return 'Saisissez une adresse e-mail valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _institutionController,
                    decoration: const InputDecoration(
                      labelText: 'Établissement',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    validator: (value) => value == null ||
                            value.trim().isEmpty
                        ? 'L’établissement est obligatoire'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _programController,
                    decoration: const InputDecoration(
                      labelText: 'Formation',
                      prefixIcon: Icon(Icons.workspace_premium_outlined),
                    ),
                    validator: (value) => value == null ||
                            value.trim().isEmpty
                        ? 'La formation est obligatoire'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le mot de passe est obligatoire';
                      }
                      if (value.length < 6) {
                        return 'Au moins 6 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmationController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmation du mot de passe',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    validator: (value) =>
                        value != _passwordController.text
                            ? 'Les mots de passe ne correspondent pas'
                            : null,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _register,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Créer mon compte'),
                  ),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => context.go('/login'),
                    child: const Text('Déjà inscrit(e) ? Se connecter'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

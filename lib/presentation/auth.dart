import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker_flutter/providers/providers.dart';

class Authentication extends ConsumerStatefulWidget {
  const Authentication({super.key});

  @override
  ConsumerState<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends ConsumerState<Authentication> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isEmpty = false;

  void _handleAuthentication(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isEmpty = true;
      });
      return;
    }
    final authProv = ref.read(authProvider);
    await authProv.login(email, password);
    final user = authProv.user;
    if (user != null) {
      if (mounted) context.go('/home');
    } else {
      setState(() {
        _isEmpty = true;
      });
    }
  }

  void _handleRegister(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _isEmpty = true;
      });
      return;
    }
    final authProv = ref.read(authProvider);
    await authProv.register(email, password);
    final user = authProv.user;
    if (user != null) {
      if (mounted) context.go('/home');
    } else {
      setState(() {
        _isEmpty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProv = ref.watch(authProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.login_outlined,
                size: MediaQuery.of(context).size.width * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Email'),
                    suffixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Password'),
                    suffixIcon: Icon(Icons.password_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _handleAuthentication(
                    _emailController.text,
                    _passwordController.text,
                  ),
                  child: const Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () => _handleRegister(
                  _emailController.text,
                  _passwordController.text,
                ),
                child: const Text('Create account'),
              ),
              Text(
                _isEmpty
                    ? (authProv.message.isNotEmpty
                        ? authProv.message
                        : 'Fill All Fields')
                    : '',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

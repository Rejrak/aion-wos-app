import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wos/blocs/auth/auth_repository.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  /// Load saved credentials if "Remember Me" was checked.
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('userId');
    final savedPassword = prefs.getString('password');
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe) {
      setState(() {
        _userIdController.text = savedUserId ?? '';
        _passwordController.text = savedPassword ?? '';
        _rememberMe = rememberMe;
      });
    }
  }

  /// Save credentials if "Remember Me" is checked.
  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('userId', _userIdController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('userId');
      await prefs.remove('password');
    }
    await prefs.setBool('rememberMe', _rememberMe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Screen')),
      body: BlocProvider(
        create: (context) => AuthBloc(authRepository: AuthRepository()),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is AuthSuccess) {
              await _saveCredentials();
              Navigator.pushNamed(context, '/trainingPlans');
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildUserIdField(),
                        const SizedBox(height: 16),
                        _buildPasswordField(),
                        const SizedBox(height: 16),
                        _buildRememberMeCheckbox(),
                        const SizedBox(height: 16),
                        _buildActionButtons(context),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// TextField for User ID with validation.
  Widget _buildUserIdField() {
    return TextField(
      controller: _userIdController,
      decoration: InputDecoration(
        labelText: 'User ID',
        errorText: validateUserId(_userIdController.text),
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) {
        // Force re-render to update validation
      },
    );
  }

  /// TextField for Password with validation.
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: validatePassword(_passwordController.text),
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) {
        // Force re-render to update validation
      },
    );
  }

  /// Checkbox for "Remember Me" option.
  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
        ),
        const Text('Remember Me'),
      ],
    );
  }

  /// Action buttons for Register and Login.
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            final userId = _userIdController.text;
            final password = _passwordController.text;
            if (validateUserId(userId) == null &&
                validatePassword(password) == null) {
              context
                  .read<AuthBloc>()
                  .add(RegisterEvent(userId: userId, password: password));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fix input errors')),
              );
            }
          },
          child: const Text('Register'),
        ),
        ElevatedButton(
          onPressed: () {
            final userId = _userIdController.text;
            final password = _passwordController.text;
            if (validateUserId(userId) == null &&
                validatePassword(password) == null) {
              context
                  .read<AuthBloc>()
                  .add(LoginEvent(userId: userId, password: password));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fix input errors')),
              );
            }
          },
          child: const Text('Login'),
        ),
      ],
    );
  }

  /// Validate User ID input.
  String? validateUserId(String value) {
    if (value.isEmpty) {
      return 'User ID is required';
    } else if (value.length < 5) {
      return 'User ID must be at least 5 characters long';
    }
    return null;
  }

  /// Validate Password input.
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}

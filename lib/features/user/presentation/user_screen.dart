import 'package:flutter/material.dart';

import '../../../app/ext/context_ext.dart';
import '../domain/state/user_state.dart';
import './components/user_created.dart';
import './components/user_error.dart';

/// Экран аутентификации пользователя
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  /// Контроллер для текстового поля ввода имени пользователя
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  /// Режим экрана: true - регистрация, false - вход
  bool _isSignUpMode = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Пытаемся восстановить пользователя при старте
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.di.userCubit.restoreUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUpMode ? 'Регистрация' : 'Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: context.di.userCubit.stateNotifier,
            builder: (context, state, child) {
              return switch (state) {
                // Если состояние загрузки или успеха - показываем соответствующие виджеты
                UserLoadingState() => const CircularProgressIndicator(),
                UserSuccessState() => UserCreated(userEntity: state.userEntity),

                // Если ошибка - показываем сообщение об ошибке
                UserErrorState() => UserError(
                  message: state.message,
                  onRetry: () {
                    // Сбрасываем состояние для повторной попытки
                    context.di.userCubit.emit(UserInitState());
                  },
                ),

                // Если инициализация - показываем форму
                UserInitState() => SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Переключатель режима
                      SwitchListTile(
                        title: Text(_isSignUpMode ? 'Регистрация' : 'Вход'),
                        subtitle: Text(_isSignUpMode ? 'Создать новый аккаунт' : 'Войти в существующий аккаунт'),
                        value: _isSignUpMode,
                        onChanged: (value) {
                          setState(() {
                            _isSignUpMode = value;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // Поле email (только для регистрации/входа по email)
                      if (!_isSignUpMode || _isSignUpMode)
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder(), prefixIcon: Icon(Icons.email)),
                          keyboardType: TextInputType.emailAddress,
                        ),

                      const SizedBox(height: 16),

                      // Поле имени пользователя
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: 'Имя пользователя', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                      ),

                      const SizedBox(height: 16),

                      // Поле пароля
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Пароль', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
                        obscureText: true,
                      ),

                      const SizedBox(height: 24),

                      // Кнопки действий
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSignUpMode ? _handleSignUp : _handleSignIn,
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                              child: Text(_isSignUpMode ? 'Зарегистрироваться' : 'Войти'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Кнопка для анонимного входа
                      OutlinedButton(onPressed: _handleAnonymousSignIn, child: const Text('Войти анонимно')),

                      const SizedBox(height: 16),

                      // Ссылка на смену режима
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignUpMode = !_isSignUpMode;
                          });
                        },
                        child: Text(_isSignUpMode ? 'Уже есть аккаунт? Войти' : 'Нет аккаунта? Зарегистрироваться'),
                      ),
                    ],
                  ),
                ),
              };
            },
          ),
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_usernameController.text.isEmpty) {
      _showError('Введите имя пользователя');
      return;
    }

    if (_emailController.text.isEmpty) {
      _showError('Введите email');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showError('Введите пароль');
      return;
    }

    context.di.userCubit.signUpOrSignIn(_emailController.text, _passwordController.text, _usernameController.text);
  }

  void _handleSignIn() {
    if (_emailController.text.isEmpty) {
      _showError('Введите email');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showError('Введите пароль');
      return;
    }

    context.di.userCubit.signIn(_emailController.text, _passwordController.text);
  }

  void _handleAnonymousSignIn() {
    if (_usernameController.text.isEmpty) {
      _showError('Введите имя пользователя');
      return;
    }

    context.di.userCubit.signInAnonymously(_usernameController.text);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

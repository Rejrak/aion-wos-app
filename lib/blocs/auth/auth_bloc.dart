import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wos/blocs/auth/auth_repository.dart';
import 'package:wos/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegisterEvent);
    on<LoginEvent>(_onLoginEvent);
  }

  Future<void> _onRegisterEvent(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.registerUser(User(userId: event.userId, password: event.password));
      emit(AuthSuccess()); // Passaggio dell'userId
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.loginUser(event.userId, event.password);
      if (user != null) {
        // Salva lo userId nella sessione
        UserSession().userId = user.userId;
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: 'Invalid credentials'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

}


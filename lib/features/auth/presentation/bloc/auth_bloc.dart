import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failure.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.authRepository,
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('🔐 Login requested for email: ${event.email}');
    emit(const AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        print('❌ Login failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (user) {
        print('✅ Login successful for user: ${user.email}');
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final Either<Failure, void> result = await authRepository.logout();

    result.fold(
      (Failure failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await authRepository.isLoggedIn();

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (isLoggedIn) {
        if (isLoggedIn) {
          // TODO: Get current user and emit AuthAuthenticated
          emit(const AuthUnauthenticated());
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pharmacy_management/features/auth/data/models/pharmacy_model.dart';
import 'package:pharmacy_management/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final pharmacy = await _authRepository.signUp(
          event.email,
          event.password,
          event.name,
        );
        emit(AuthAuthenticated(pharmacy));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final pharmacy = await _authRepository.login(
          event.email,
          event.password,
        );
        emit(AuthAuthenticated(pharmacy));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<GoogleSignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final pharmacy = await _authRepository.googleSignIn();
        emit(AuthAuthenticated(pharmacy));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignOutEvent>((event, emit) async {
      await _authRepository.signOut();
      emit(AuthInitial());
    });
  }
}
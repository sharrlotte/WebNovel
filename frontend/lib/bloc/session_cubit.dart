import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/models/session.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SessionState {}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class Authenticated extends SessionState {
  final Session session;

  Authenticated(this.session);
}

class Unauthenticated extends SessionState {}

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> signInWithGoogle() async {
    emit(SessionLoading());

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final auth = await googleUser.authentication;
        String? idToken = auth.idToken;

        if (idToken != null) {
          final response = await Dio().post(
            '${dotenv.env['API_URL']}/auth/google',
            data: {'idToken': idToken},
          );

          emit(Authenticated(Session.fromJson(response.data)));
        } else {
          emit(Unauthenticated());
        }
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
      emit(Unauthenticated());
    }
  }

  Future<void> signOut() async {
    emit(Unauthenticated());
      await googleSignIn.signOut();
  }
}

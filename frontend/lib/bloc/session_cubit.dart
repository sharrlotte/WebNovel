import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/session.dart';
import 'package:frontend/utils.dart';
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
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  SessionCubit() : super(SessionLoading()) {
    load();
  }

  void load() async {
    const storage = FlutterSecureStorage();

    storage.read(key: "session").then((session) {
      if (session != null) {
        getApi().options.headers['Authorization'] =
            "Bearer ${jsonDecode(session)['accessToken']}";

        emit(Authenticated(Session.fromJson(jsonDecode(session))));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<SessionState> signInWithGoogle() async {
    emit(SessionLoading());

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final auth = await googleUser.authentication;
        String? idToken = auth.idToken;

        if (idToken != null) {
          final response = await getApi().post(
            '${dotenv.env['API_URL']}/auth/google',
            data: {'idToken': idToken},
          );

          const storage = FlutterSecureStorage();
          // ignore: prefer_interpolation_to_compose_strings
          getApi().options.headers['Authorization'] =
              "Bearer ${response.data['accessToken']}";

          getApi().interceptors.clear();

          getApi().interceptors.add((InterceptorsWrapper(
                onError: (error, handler) {
                  if (error.response?.statusCode == 403) {
                    getApi().options.headers['Authorization'] = null;
                  }
                },
              )));

          await storage.write(key: 'session', value: jsonEncode(response.data));

          final state = Authenticated(Session.fromJson(response.data));
          emit(state);

          return state;
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
    return Unauthenticated();
  }

  Future<void> signOut() async {
    const storage = FlutterSecureStorage();

    await googleSignIn.signOut();

    storage.delete(key: "session");

    emit(Unauthenticated());
  }
}

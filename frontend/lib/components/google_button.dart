import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/session_cubit.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, session) {
      if (session is SessionLoading) {
        return const CircularProgressIndicator();
      }

      if (session is! Authenticated) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            final cubit = context.read<SessionCubit>();
            await cubit.signInWithGoogle();
            
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                ),
                SizedBox(
                  width: 40,
                ),
                Text(
                  'Đăng nhập bằng Google',
                ),
              ],
            ),
          ),
        );
      }

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          context.read<SessionCubit>().signOut();
        },
        child: const Text("Đăng xuất?"),
      );
    });
  }
}

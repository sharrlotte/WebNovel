import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/session_cubit.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SessionCubit>();

    if (cubit.state is Unauthenticated) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
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
                'Login With Google',
              ),
            ],
          ),
        ),
      );
    }

    return const Text("Đã đăng nhập");
  }
}

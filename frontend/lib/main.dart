import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fquery/fquery.dart';
import 'package:frontend/bloc/session_cubit.dart';
import 'package:frontend/components/custom_app_bar.dart';
import 'package:frontend/pages/upload_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return QueryClientProvider(
          queryClient: QueryClient(),
          child: BlocProvider(
              create: (_) => SessionCubit(),
              child: MaterialApp(
                title: 'Novel App',
                theme: ThemeData(
                  primaryColor: Colors.pink[200],
                  scaffoldBackgroundColor: Colors.white,
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => const NavScaffold(body: HomePage()),
                  '/login': (context) => const NavScaffold(body: LoginPage()),
                  "/upload": (context) => const NavScaffold(body: UploadPage())
                },
              )));
    } catch (e) {
      return const Text("Lỗi");
    }
  }
}

class NavScaffold extends StatelessWidget {
  final Widget body;

  const NavScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const CustomAppBar(), body: body);
  }
}

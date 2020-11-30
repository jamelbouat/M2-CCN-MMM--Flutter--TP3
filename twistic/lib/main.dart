import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twistic/services/Authentication.dart';
import 'package:twistic/ui/SignInScreen.dart';
import 'package:twistic/ui/TweetListScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<Authentication>(
            create: (_) => Authentication(FirebaseAuth.instance),
          ),
          StreamProvider(
              create: (context) => context.read<Authentication>().authStateChanges,
          )
        ],
        child: MaterialApp(
          title: 'twistic demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: AuthenticationWrapper(),
        )
    );

  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    return user != null ? TweetListScreen(user) : SignInScreen();
  }
}

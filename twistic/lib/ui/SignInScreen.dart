import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:twistic/services/Authentication.dart';

import 'RegisterScreen.dart';

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() {
    return SignInScreenState();
  }
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Authentication authentication = Authentication(FirebaseAuth.instance);

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return loading ? LoadingWidget() :
    Scaffold(
        appBar: AppBar(
          title: Text("Sign in to twistic"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _connexion();
                  },
                  child: Text('Sign in'),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToRegisterScreen(context);
                  },
                  child: Text('Sign up'),
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> _connexion() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading= true;
      });
      try {
        await authentication.signIn(emailController.text, passwordController.text);
        setState(() {
          loading= false;
        });
      } on Exception catch (e) {
        setState(() {
          loading = false;
        });
      }
    }
  }

}

void _navigateToRegisterScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => RegisterScreen()),
  );
}

class LoadingWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          )
      ),
    );
  }
}
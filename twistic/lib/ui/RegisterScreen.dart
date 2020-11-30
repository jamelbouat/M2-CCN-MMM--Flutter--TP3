import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:twistic/services/Authentication.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final Authentication authentication = Authentication(FirebaseAuth.instance);

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    return loading ? LoadingWidget() :
    Scaffold(
        appBar: AppBar(
          title: Text("Sign up to twistic"),
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
                    return 'Please enter some a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: pseudoController,
                decoration: const InputDecoration(labelText: 'Pseudo'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a pseudo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'Video url'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid url';
                  }
                  return null;
                },
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                      _register();
                  },
                  child: Text('Sign up'),
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading= true;
      });
      try {
        await authentication.signUp(emailController.text,
                                    passwordController.text,
                                    pseudoController.text,
                                    urlController.text
        );
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
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth firebaseAuth;

  Authentication(this.firebaseAuth);

  Stream<User> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> signIn(String email, String password) async{
    try {
      UserCredential response = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return response.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signOut() async{
    await firebaseAuth.signOut();
  }

  Future<void> signUp(String email, String password, String pseudo, String url) async{
    try {
      UserCredential response = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      response.user.updateProfile(displayName: pseudo, photoURL: url);
      await signIn(response.user.email, password);

    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

}
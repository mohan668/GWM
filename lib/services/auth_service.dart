import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<User?> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update Firebase Auth display name
        await user.updateDisplayName(name);

        // Save data in Firestore under 'users/{uid}'
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': name,
          'email': email.trim(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Sign Up Failed';
    }
  }

  static Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Login Failed';
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? get currentUser => _auth.currentUser;
}

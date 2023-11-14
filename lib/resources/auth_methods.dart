import 'dart:typed_data';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Get User Details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User(
      email: (snap.data() as Map<String, dynamic>)['email'],
      username: (snap.data() as Map<String, dynamic>)['username'],
      bio: (snap.data() as Map<String, dynamic>)['bio'],
      uid: (snap.data() as Map<String, dynamic>)['uid'],
      photoUrl: (snap.data() as Map<String, dynamic>)['photoUrl'],
      following: (snap.data() as Map<String, dynamic>)['following'],
      followers: (snap.data() as Map<String, dynamic>)['followers'],
    );
  }

  //SIGN UP USER
  Future<String> signupUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file.isNotEmpty != null) {
        //Register User
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        // Add User TO Database
        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl
        );
         _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

        // UID Will be different
        // await _firestore.collection('users').add({
        //   'username' : username,
        //   'uid' : cred!.user!.uid,
        //   'email' : email,
        //   'bio' : bio,
        //   'followers' : [],
        //   'following' : []
        // });

        res = 'success!';
      }
    } on FirebaseException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'This is a weak password, try another';
      } else if (err.code ==
          'The email address is already in use by another account') {
        res = "The email address is already in use by another account";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  // SIGN IN USER
  Future<String> signinUser(
      {required String email, required String password}) async {
    String res = 'some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'User Does Not Exist';
      } else if (e.code == 'wrong-password') {
        res = 'Password is wrong';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}

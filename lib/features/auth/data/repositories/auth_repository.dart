import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharmacy_management/core/constants/constants.dart';
import 'package:pharmacy_management/features/auth/data/models/pharmacy_model.dart';
import 'package:pharmacy_management/features/auth/domain/auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<PharmacyModel> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        PharmacyModel pharmacy = PharmacyModel(
          id: user.uid,
          name: name,
          email: email,
        );
        await _firestore
            .collection(Constants.pharmacyCollection)
            .doc(user.uid)
            .set(pharmacy.toJson());
        return pharmacy;
      }
      throw Exception('Sign-up failed');
    } catch (e) {
      throw Exception('Sign-up error: $e');
    }
  }

  @override
  Future<PharmacyModel> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot doc = await _firestore
            .collection(Constants.pharmacyCollection)
            .doc(user.uid)
            .get();
        return PharmacyModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      throw Exception('Login failed');
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<PharmacyModel> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google Sign-In cancelled');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot doc = await _firestore
            .collection(Constants.pharmacyCollection)
            .doc(user.uid)
            .get();
        if (!doc.exists) {
          PharmacyModel pharmacy = PharmacyModel(
            id: user.uid,
            name: user.displayName ?? 'Pharmacy',
            email: user.email ?? '',
          );
          await _firestore
              .collection(Constants.pharmacyCollection)
              .doc(user.uid)
              .set(pharmacy.toJson());
          return pharmacy;
        }
        return PharmacyModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      throw Exception('Google Sign-In failed');
    } catch (e) {
      throw Exception('Google Sign-In error: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
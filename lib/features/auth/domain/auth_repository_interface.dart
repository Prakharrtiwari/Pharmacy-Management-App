import 'package:pharmacy_management/features/auth/data/models/pharmacy_model.dart';

abstract class AuthRepositoryInterface {
  Future<PharmacyModel> signUp(String email, String password, String name);
  Future<PharmacyModel> login(String email, String password);
  Future<PharmacyModel> googleSignIn();
  Future<void> signOut();
}
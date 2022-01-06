

import 'firebase_auth_api.dart';
class AuthRepository {
  final _firebaseAuthAPI = FirebaseAuthAPI();



  signOut() => _firebaseAuthAPI.signOut();

}

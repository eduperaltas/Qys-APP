
import 'package:qys/Usuarios/repository/auth_repository.dart';

import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserBloc implements Bloc {

  final _auth_repository = AuthRepository();
  //Flujo de datos - Streams
  //Stream - Firebase
  //StreamController
  Stream streamFirebase = FirebaseAuth.instance.authStateChanges();

  Stream get authStatus => streamFirebase;


  //Casos uso
  //1. SignIn a la aplicación Google

  signOut() {
    _auth_repository.signOut();
  }


  @override
  void dispose() {

  }
}


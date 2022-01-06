
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qys/Widget/MyPreferences.dart';



class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  MyPreferences _myPreferences = MyPreferences();



  Future registerWithEmailAndPassword(String email, String password) async{

    try{
      UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      return user;

    }catch(e){
      print(e.toString());
      return null;

    }
    /*FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user;*/
  }
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _myPreferences.uid = user.user.uid; //guardo en cache
      _myPreferences.commit();
      print('ahi va es:');
      print(_myPreferences.uid);

      return user;

    }catch(e){
      print(e.toString());
      return null;

    }
   /* FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user;*/
  }

  signOut() async {
    await _auth.signOut();
  }


}
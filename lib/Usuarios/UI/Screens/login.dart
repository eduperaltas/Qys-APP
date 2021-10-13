import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qys/Usuarios/bloc/bloc_user.dart';
import 'package:qys/Usuarios/repository/firebase_auth_api.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:qys/Widget/MyPreferences.dart';
import 'Home.dart';

class SignInScreen extends StatefulWidget {

  @override
  State createState() {
    return _SignInScreen();
  }
}
class _SignInScreen extends State<SignInScreen> {
  final  FirebaseAuthAPI _auth = FirebaseAuthAPI();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String _email, _password;
  String error ="";
  UserBloc userBloc;
  MyPreferences _myPreferences = MyPreferences();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userBloc = BlocProvider.of(context);
    return _handleCurrentSession();
  }

  Widget _handleCurrentSession(){
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot- data - Object User
        if(!snapshot.hasData || snapshot.hasError) {
          return LoginUser();
        } else {
          final User user = auth.currentUser;
          final uid = user.uid;
          _myPreferences.uid = uid;
          _myPreferences.commit();

          print("USER UID login: " + _myPreferences.uid);
          return EditTicket();
        }
      },
    );

  }
  Widget  LoginUser(){
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/logosinfondo.png',
                  height: 250,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Inicia Sesión",
                  style: _theme.textTheme.headline1.merge(
                    TextStyle(
                      fontFamily: "the-foregen-rough-one",
                      fontSize: 30.0,
                      color: Colors.black,),
                  ),
                ),
              ),

              SizedBox(
                height: 30.0,
              ),
              _loginForm(context),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {


    return Container(
      height: MediaQuery.of(context).size.height*0.9,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular((20.0))),
                shape: BoxShape.rectangle,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: '  Email',
                ),
                validator: (input)=> input.isEmpty ? 'Ingresa un Email válido' : null,
                onChanged: (val){
                  setState(() => _email = val);
                },

              ),
            ),

            SizedBox(
              height: 20.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular((20.0))),
                shape: BoxShape.rectangle,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: '  Contraseña'
                ),
                obscureText: true,
                validator: (input)=> input.length < 6 ? 'Ingresa una contraseña de más de seis carácteres' : null,
                onChanged: (val){
                  setState(() => _password = val);
                },
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45.0,
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: Colors.black,
                onPressed: () async {
                  /*Navigator.push(
                      context,
                      PageTransition(child: AddTicket(), type: PageTransitionType.rightToLeft));*/
                  if(_formKey.currentState.validate()){
                    await _auth.signInWithEmailAndPassword(_email, _password);
                  }
                },
                child: Text(
                  "Inicia Sesíon",
                  style: TextStyle(color: Colors.white, fontSize: 20.0,
                      fontFamily: "BAHNSCHRIFT"),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _myPreferences.init().then((value) {
      setState(() {
        _myPreferences = value;
      });
    });
  }
}

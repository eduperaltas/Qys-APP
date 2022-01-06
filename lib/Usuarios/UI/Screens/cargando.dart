import 'package:flutter/material.dart';
class loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logosinfondo.png',
              height: 60,
            ),
          ],
        ),),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 100.0,
              ),
              Image.asset("assets/images/loading.png"),
              SizedBox(
                height: 30.0,
              ),
              Text("Cargando . . . ",style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),),
              SizedBox(
                height: 30.0,
              ),

              Container(
                child:CircularProgressIndicator(),
              ),

            ],
          )),
    );
  }


}
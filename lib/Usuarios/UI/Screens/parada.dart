import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qys/Usuarios/UI/Screens/cargando.dart';
import 'package:qys/Usuarios/UI/Screens/Home.dart';
import 'package:qys/Usuarios/repository/cloud_firestore_api.dart';
import 'package:qys/Usuarios/UI/Widgets/data_field.dart';
import 'package:flutter/material.dart';
import 'package:qys/Widget/MyPreferences.dart';

class screenParada extends StatefulWidget {
  String titulo;
  String docID;
  int num;
  String initialValue;
  void Function(String) onValueChange;
  screenParada({this.titulo, this.docID, this.num});
  @override
  State createState() {
    return _screenParada();
  }
}
class _screenParada extends State<screenParada> {

  File sampleImage;
  String url;
  final formKey = new GlobalKey<FormState>();

  DateTime selectedDate;
  DateTime selectedDate1;
  DateTime selectedDate2;
  DateTime selectedDate3;
  DateTime selectedDate4;
  DateTime selectedDate5;
  String _inicio,_fin,_motivo,_nParada;
  MyPreferences _myPreferences = MyPreferences();
  String _selectedId;
  String _inicioHora;
  String _inicioFecha;
  String _finFecha;
  int turno;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    print('----------------EN PARADA DOCID: '+ widget.docID);
    print('----------------EN PARADA NUM: '+ widget.num.toString());
    return  StreamBuilder(
        stream: FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas')
            .collection('ids').doc(widget.docID).collection('paradas').doc(widget.num.toString()).snapshots(),
    builder: (context, AsyncSnapshot snapshot) {
    if(!snapshot.hasData){
    return loading();
    }else{
      var parada = snapshot.data;
      turno = parada['turno fin']!=null?parada['turno fin']:parada['turno inicio'];
      return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
            onPressed: () {
              switch(_selectedId){
                case'Turno 1': { turno=1; break;}
                case'Turno 2': { turno=2;break ;}
                case'Turno 3': { turno=3;break ;}
              };

              CloudFirestoreAPI(docID: widget.docID).guardar_parada(
                   widget.num,_finFecha,_fin,
                  _motivo, turno, _inicioHora,_inicioFecha);

              if (Navigator.of(context).canPop()) {
                Navigator.push(context,PageTransition(child: EditTicket(), type: PageTransitionType.leftToRight));
              }
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(widget.titulo, style:
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: "BAHNSCHRIFT",
                    fontSize: 40.0,
                  ),
                  ),
                ),
              )
            ],
          ),),
        body: SingleChildScrollView(
            child: Container(
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Card(
                        elevation: 8,
                        margin: EdgeInsets.only(
                            top: 20,
                            left: 16,
                            right: 16,
                            bottom: 16
                        ),
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  child: Text( "Ingrese información de la parada"+ ": ",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "BAHNSCHRIFT",
                                        fontWeight: FontWeight.w900
                                    ),
                                  ),
                                ),SizedBox(
                                  height: 50.0,
                                ),
                                Container(
                                  child: Text( "Numero de parada"+ ": "+ widget.num.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "BAHNSCHRIFT",
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Text( "Fecha inicio"+ ":   ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "BAHNSCHRIFT",
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left:20),
                                      width: 210,
                                      child: DateTimeField(
                                        label: parada['inicio dia']!=null?parada['inicio dia'] : "Selecciona Fecha",
                                        mode: DateFieldPickerMode.date,
                                        selectedDate: selectedDate2,
                                        onDateSelected: (DateTime date) {
                                          setState(() {
                                            selectedDate2 = date;
                                            _inicioFecha=date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Text( "Hora inicio"+ ":",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "BAHNSCHRIFT",
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left:40),
                                      width: 230,
                                      child: DateTimeField(
                                        label: parada['inicio hora']!=null?parada['inicio hora'] :"Selecciona una hora",
                                        mode: DateFieldPickerMode.time,
                                        selectedDate: selectedDate2,
                                        onDateSelected: (DateTime date) {
                                          setState(() {
                                            selectedDate2 = date;
                                            _inicioHora=date.hour.toString()+':'+date.minute.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 30.0,
                                ),

                                Row(
                                  children: [
                                    Container(
                                      child: Text( "Fecha fin"+ ":         ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "BAHNSCHRIFT",
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left:20),
                                      width: 210,
                                      child: DateTimeField(
                                        label:  parada['fin dia']!=null?parada['fin dia'] :"Selecciona Fecha",
                                        mode: DateFieldPickerMode.date,
                                        selectedDate: selectedDate3,
                                        onDateSelected: (DateTime date) {
                                          setState(() {
                                            selectedDate3 = date;
                                            _finFecha=date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Text( "Hora fin"+ ":       ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "BAHNSCHRIFT",
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left:40),
                                      width: 226,
                                      child: DateTimeField(
                                        label:  parada['fin hora']!=null?parada['fin hora'] :"Selecciona una hora",
                                        mode: DateFieldPickerMode.time,
                                        selectedDate: selectedDate1,
                                        onDateSelected: (DateTime date) {
                                          setState(() {
                                            selectedDate1 = date;
                                            _fin=date.hour.toString()+':'+date.minute.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Text( "Turno fin"+ ":",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "BAHNSCHRIFT",
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.only(left:58),
                                        child: new DropdownButton<String>(
                                          hint: Text(parada['turno fin']!=null?'Turno '+parada['turno fin'].toString() :"Selecciona turno        "),
                                          value: _selectedId,
                                          onChanged: (String value) {
                                            setState(() {
                                              _selectedId = value;
                                            });
                                            widget.onValueChange(value);
                                          },
                                          items: <String>['Turno 1', 'Turno 2', 'Turno 3'].map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value,textAlign: TextAlign.center),
                                            );
                                          }).toList(),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                Container(
                                  child: Text( "Motivo"+ ": ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "BAHNSCHRIFT",
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Form(
                                  //key: _formKey,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: parada['motivo']!=null?parada['motivo'] :""
                                    ),
                                    obscureText: false,
                                    validator: (input){
                                      if (input.isEmpty) {
                                        return 'ingrese el motivo de la parada';
                                      }
                                      else
                                        return null;
                                    },
                                    onChanged: (val){
                                      setState(() {
                                        _motivo= val;
                                      });
                                    },
                                  ),
                                ),

                                SizedBox(
                                  height: 40.0,
                                ),

                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.black,
                                    onPressed: () async {
                                      switch(_selectedId){
                                        case'Turno 1': { turno=1; break;}
                                        case'Turno 2': { turno=2;break ;}
                                        case'Turno 3': { turno=3;break ;}
                                      }
                                      _finFecha=_finFecha!=null?_finFecha:parada['fin dia'];
                                      _fin        =_fin!=null?_fin :parada['fin hora'];
                                      _motivo     =_motivo!=null?_motivo :parada['motivo'];
                                      turno       =turno!=null? turno:parada['turno fin'];
                                      _inicioHora =_inicioHora!=null?_inicioHora :parada['inicio hora'];
                                      _inicioFecha=_inicioFecha!=null?_inicioFecha :parada['inicio dia'];

                                      if(_motivo.isNotEmpty || turno!=0) {
                                        CloudFirestoreAPI(docID: widget.docID).terminar_parada(
                                             widget.num,_finFecha,_fin,
                                            _motivo, turno, _inicioHora,_inicioFecha);
                                        Navigator.push(context,PageTransition(child: EditTicket(), type: PageTransitionType.leftToRight));
                                      }
                                    },
                                    child: Text(
                                      "Finalizar parada",
                                      style: TextStyle(color: Colors.white, fontSize: 20.0,
                                          fontFamily: "BAHNSCHRIFT"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    )
                  ],
                ))),
      );
    }
    });


  }



  double screenHeightExcludingToolbar(BuildContext context, {double dividedBy = 1}) {
    return screenHeight(context, dividedBy: dividedBy, reducedBy: kToolbarHeight);
  }

  double screenWidth(BuildContext context, {double dividedBy = 1}) {
    return screenSize(context).width / dividedBy;
  }

  double screenHeight(BuildContext context, {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

}
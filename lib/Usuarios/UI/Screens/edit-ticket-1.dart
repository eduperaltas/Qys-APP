import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qys/Usuarios/UI/Screens/cargando.dart';
import 'package:qys/Usuarios/UI/Screens/parada.dart';
import 'package:qys/Usuarios/UI/Widgets/data_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:qys/Usuarios/model/carga.dart';
import 'package:qys/Usuarios/repository/cloud_firestore_api.dart';
import 'package:qys/Widget/MyPreferences.dart';
import 'package:intl/intl.dart';
import 'package:qys/main.dart';

import 'Home.dart';
import 'edtit-ticket-2.dart';
class EditTicketDetail extends StatefulWidget {
  String title, docID;

  EditTicketDetail({this.title, this.docID});

  @override
  _EditTicketDetailState1 createState() => _EditTicketDetailState1();
}


class _EditTicketDetailState1 extends State<EditTicketDetail> {
  String _myActivity;
  String _empresa_transporte;
  String _origen;
  String _destino;
  String _tipo_carga;
  String _placa_carretera;
  String _equipo_carga;
  String _rampa;
  String _cam_fecha_cita;
  var _numTim;
  var _cam_hora_cita;
  int n_parada;
  String _fecha_programacion;
  DateTime selectedDate;
  DateTime selectedDate1;
  MyPreferences _myPreferences = MyPreferences();


  @override
  void initState() {
    super.initState();
    _myActivity = '';
  }

  Widget title(String txt){
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text( txt+ ": ",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "BAHNSCHRIFT",
                fontWeight: FontWeight.w600
            ),
          ),
        ),

      ],
    );
  }



  _setchanges(Carga cargadb){
    cargadb.numero_TIM = _numTim;
    cargadb.empresa_de_transporte = _empresa_transporte; 
    cargadb.origen = _origen; 
    cargadb.destino = _destino; 
    cargadb.placa_carretera = _placa_carretera; 
    cargadb.equipo_de_carga = _equipo_carga; 
    cargadb.rampa = _rampa; 
    cargadb.fecha_programacion = _fecha_programacion; 
    cargadb.camion_fecha_cita = _cam_fecha_cita; 
    cargadb.camion_hora_cita = _cam_hora_cita; 
    cargadb.tipo_de_carga = _tipo_carga; 
  }
  
  get checkBoxValue => null;
  @override
  Widget build(BuildContext context) {
    
    String titulo = this.widget.title;
    print('DOCID EN EDIT1 ES:    ' + this.widget.docID);

    return  StreamBuilder(
        stream: CloudFirestoreAPI(docID: this.widget.docID).cargaData,
        builder: (context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData){
          return loading();
        }else{
          Carga carga = snapshot.data;
          n_parada=carga.N_paradas;
          //VEREMOS EN QUE ESTADO SE ENCUENTRA EL TICKET
          if(carga.estado=='parada'){
            return screenParada(titulo: titulo,docID: this.widget.docID,num: carga.N_paradas,);
          }else{
            return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: Color.fromARGB(1000, 0, 84, 173),
              automaticallyImplyLeading: true,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(titulo, style:
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "BAHNSCHRIFT",
                        fontSize: 35.0,
                      ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height:4.0,
                      ),
                      Container(
                        height: 43,
                        width: 45,
                        child: FloatingActionButton(
                          onPressed: () async {
                            _dialogParada(titulo);

                          },
                          backgroundColor: Colors.white,
                          tooltip: 'Add Image',
                          child: Icon(Icons.warning,color: Colors.red,),
                        ),
                      ),
                      Text('Parada', style:
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "BAHNSCHRIFT",
                        fontSize: 11.0,
                      ),
                      ),
                    ],
                  ),
                ],
              ),),
            body: SingleChildScrollView(
                child: Container(
                    color:  Color.fromARGB(1000, 0, 84, 173),
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
                                      child: Text( "Ingrese información del cliente"+ ": ",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: "BAHNSCHRIFT",
                                            fontWeight: FontWeight.w900
                                        ),
                                      ),
                                    ),SizedBox(
                                      height: 30.0,
                                    ),
                                    title('Numero TIM'),
                                    Form(
                                      // key: _formKey,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: carga.numero_TIM
                                        ),
                                        keyboardType: TextInputType.number,
                                        obscureText: false,
                                        validator: (input)=> input.isEmpty ? 'Ingrese un número TIM' : null,
                                        onChanged: (val){
                                          setState(() {
                                            _numTim=val;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),

                                    title('Fecha Programación'),
                                    DateTimeField(
                                      label: carga.fecha_programacion==null?"Selecciona una fecha":carga.fecha_programacion,
                                      mode: DateFieldPickerMode.date,
                                      selectedDate: selectedDate,
                                      onDateSelected: (DateTime date) {
                                        setState(() {
                                          selectedDate = date;
                                          _fecha_programacion=date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                                        });
                                      },

                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),

                                    title("Empresa de Transporte"),
                                    Form(
                                      // key: _formKey,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: carga.empresa_de_transporte
                                        ),
                                        obscureText: false,
                                        validator: (input)=> input.isEmpty ? 'Ingrese dato' : null,
                                        onChanged: (val){
                                          setState(() {
                                            _empresa_transporte=val;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),

                                    title("Origen"),
                                    Form(
                                      // key: _formKey,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: carga.origen
                                        ),
                                        obscureText: false,
                                        validator: (input)=> input.isEmpty ? 'Ingrese dato' : null,
                                        onChanged: (val){
                                          setState(() {
                                            _origen=val;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),

                                    title("Destino"),
                                    Form(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: carga.destino
                                        ),
                                        obscureText: false,
                                        validator: (input)=> input.isEmpty ? 'Ingrese dato' : null,
                                        onChanged: (val){
                                          setState(() {
                                            _destino=val;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),

                                    title("Tipo de carga"),
                                    Form(
                                      // key: _formKey,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            child: DropDownFormField(
                                              titleText: 'Tipo',
                                              hintText: carga.tipo_de_carga.toString()=='null'?'Escoge una opcción':carga.tipo_de_carga,
                                              value: _myActivity,
                                              onSaved: (value) {
                                                setState(() {
                                                  _myActivity = value;
                                                  _tipo_carga=value;
                                                });
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _myActivity = value;
                                                  _tipo_carga=value;
                                                });
                                              },
                                              dataSource: [
                                                {
                                                  "display": "GRANEL",
                                                  "value": "GRANEL",
                                                },
                                                {
                                                  "display": "PALETIZADO",
                                                  "value": "PALETIZADO",
                                                },
                                                {
                                                  "display": "NIVEL",
                                                  "value": "NIVEL",
                                                },
                                                {
                                                  "display": "FURGÓN",
                                                  "value": "FURGÓN",
                                                },
                                              ],
                                              textField: 'display',
                                              valueField: 'value',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),

                                    title("Placa carreta"),
                                    Form(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: carga.placa_carretera
                                        ),
                                        obscureText: false,
                                        onChanged: (val){
                                          setState(() {
                                            _placa_carretera=val;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),

                                    title("Rampa"),
                                    Form(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ], // Only numbers can be entered
                                        decoration: InputDecoration(
                                            hintText: carga.rampa
                                        ),
                                        obscureText: false,
                                        validator: (input)=> input.isEmpty ? 'Ingrese un número de rampa' : null,
                                        onChanged: (val){
                                          setState(() {
                                            _rampa= val;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),

                                    title("Equipo de carga"),
                                    Form(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText: carga.equipo_de_carga
                                        ),
                                        obscureText: false,
                                        validator: (input)=> input.isEmpty ? 'Ingrese dato' : null,
                                        onChanged: (val){
                                          setState(() {
                                            _equipo_carga= val;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),

                                    title("Camion fecha cita"),
                                    DateTimeField(
                                      label: carga.camion_fecha_cita==null?"Selecciona una fecha":carga.camion_fecha_cita,
                                      mode: DateFieldPickerMode.date,
                                      selectedDate: selectedDate1,
                                      onDateSelected: (DateTime date) {
                                        setState(() {
                                          selectedDate1 = date;
                                          _cam_fecha_cita= date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                                        });
                                      },

                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),

                                    title("Camion hora cita"),
                                    DateTimeField(
                                      label: carga.camion_hora_cita==null?"Selecciona una hora":carga.camion_hora_cita,
                                      mode: DateFieldPickerMode.time,
                                      selectedDate: selectedDate,
                                      onDateSelected: (DateTime date) {
                                        setState(() {
                                          selectedDate = date;
                                          var formattedTime = DateFormat('HH:mm').format(date);
                                          _cam_hora_cita= formattedTime;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50.0,
                                      child: FlatButton(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(30.0),
                                        ),
                                        color: Color.fromARGB(1000, 0, 84, 173),
                                        onPressed: () async {

                                          //meterlo a BD
                                          _setchanges(carga);
                                          CloudFirestoreAPI(docID: this.widget.docID).addData1(carga);

                                          //Siguiente pagina
                                          _myPreferences.tim = _numTim;
                                          _myPreferences.commit();

                                          Navigator.push(context,PageTransition(child: EditTicketDetail2(titulo:titulo, docID: this.widget.docID,), type: PageTransitionType.rightToLeft));
                                        },
                                        child: Text(
                                          "Siguiente sección",
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
        }
        });


  }

  Future<void> _dialogParada(String titulo) async {
    return showDialog(
      context: context,
      builder: (context) => MyDialog(docID: this.widget.docID,titulo: titulo,n_parada: n_parada,)
    );
  }


  // void scheduleAlarm( String carga,DateTime scheduledNotificationDateTime,int id ) async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'alarm_notif',
  //     'alarm_notif',
  //     'Channel for Alarm notification',
  //     icon: 'codex_logo',
  //     sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
  //   );
  //
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails(
  //       sound: 'a_long_cold_sting.wav',
  //       presentAlert: true,
  //       presentBadge: true,
  //       presentSound: true);
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.schedule(
  //       id,
  //       'Alerta',
  //       'Recuerda subir una foto de la carga '+ carga,
  //       scheduledNotificationDateTime,
  //       platformChannelSpecifics);
  // }
}


class MyDialog extends StatefulWidget {
  const MyDialog({this.onValueChange, this.initialValue,this.docID,this.titulo,this.n_parada});

  final String initialValue;
  final String docID;
  final String titulo;
  final int n_parada;
  final void Function(String) onValueChange;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String _selectedId;
  int turno;

  @override
  void initState() {
    super.initState();
    turno=0;
    _selectedId = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new ListTile(
        title: Text('Parada',textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20)),
        subtitle: Text('Cuando presiones ok el ticket estará en estado de parada, recuerda seleccionar tu turno.',textAlign: TextAlign.center,style: TextStyle(color: Colors.black, fontSize: 14,height: 1.5)),
      ),
      children: <Widget>[
        new Container(
            padding: const EdgeInsets.symmetric(horizontal:83),
            child: new DropdownButton<String>(
              hint: const Text("Selecciona turno"),
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
         Padding(
           padding: const EdgeInsets.symmetric(horizontal:20.0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  color: Colors.red,
                  child: Text('cancelar',style: TextStyle(color: Colors.white)),
                  onPressed: () => {

                    Navigator.of(context).pop()},
                ),

                FlatButton(
                  color: Color.fromARGB(1000, 0, 84, 173),
                  child: Text('Aceptar',style: TextStyle(color: Colors.white)),
                  onPressed: () async {

                    switch(_selectedId){
                      case'Turno 1': { turno=1; break;}
                      case'Turno 2': { turno=2;break ;}
                      case'Turno 3': { turno=3;break ;}
                    }
                    if(turno!=0){
                      CloudFirestoreAPI(docID: widget.docID).inicia_parada(widget.n_parada+1,turno);
                      Navigator.push(context,PageTransition(child: screenParada(titulo: widget.titulo,num: widget.n_parada+1, docID: widget.docID,), type: PageTransitionType.rightToLeft));
                    }
                    }

                )
              ],
            ),
         ),


      ],
    );
  }
}
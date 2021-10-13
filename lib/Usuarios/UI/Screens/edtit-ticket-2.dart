import 'package:qys/Usuarios/UI/Screens/photo-screen.dart';
import 'package:qys/Usuarios/UI/Screens/cargando.dart';
import 'package:qys/Usuarios/UI/Screens/edit-ticket-1.dart';
import 'package:qys/Usuarios/UI/Widgets/data_field.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qys/Usuarios/model/carga.dart';
import 'package:qys/Usuarios/repository/cloud_firestore_api.dart';
import 'package:qys/Widget/MyPreferences.dart';
import 'package:intl/intl.dart';

import 'Home.dart';
import 'parada.dart';

class EditTicketDetail2 extends StatefulWidget {
  String titulo, docID;
  EditTicketDetail2({this.titulo,this.docID});
  @override
  State createState() {
    return _EditTicketDetail2();
  }
}

class _EditTicketDetail2 extends State<EditTicketDetail2> {
  String _camion_fecha_llegada,_hora_fin_carga,_fecha_fin_carga,_hora_lelgada, _estiba_hora_llegada, _ases_fecha_llegada,
      _ases_hora_llegada,_ases_codigo, _fecha_ini_carga, _hora_ini_carga,_asescod;
  final formKey = new GlobalKey<FormState>();
  DateTime selectedDate;
  DateTime selectedDate1;
  DateTime selectedDate2;
  DateTime selectedDate3;
  DateTime selectedDate4;
  DateTime selectedDate5;

  int n_parada;
  MyPreferences _myPreferences = MyPreferences();

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
    cargadb.camion_fecha_llegada = _camion_fecha_llegada;
    cargadb.camion_hora_llegada = _hora_lelgada;
    cargadb.estiba_hora_llegada = _estiba_hora_llegada;
    cargadb.codigo_asesor = _ases_codigo;
    cargadb.asesoria_fecha_llegada = _ases_fecha_llegada;
    cargadb.asesoria_hora_llegada = _ases_hora_llegada;
    cargadb.fecha_inicio_carga = _fecha_ini_carga;
    cargadb.hora_inicio_carga = _hora_ini_carga;
    cargadb.fecha_fin_carga = _fecha_fin_carga;
    cargadb.hora_fin_carga = _hora_fin_carga;
  }

  @override
  Widget build(BuildContext context) {

    Future<void> _dialogParada(String titulo) async {
      return showDialog(
          context: context,
          builder: (context) => MyDialog(titulo: titulo,n_parada: n_parada,)
      );
    }

    print('DOCID EN EDIT2 ES:    ' + this.widget.docID);

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
                child: Text(widget.titulo, style:
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
                      _dialogParada(widget.titulo);

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
        body: StreamBuilder(
            stream: CloudFirestoreAPI(docID: this.widget.docID).cargaData,
            builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData){
                return loading();
              }else{
                Carga carga = snapshot.data;

                return SingleChildScrollView(
                      child: Container(
                          color: Color.fromARGB(1000, 0, 84, 173),
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
                                            child: Text( "Ingrese información de control"+ ": ",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: "BAHNSCHRIFT",
                                                  fontWeight: FontWeight.w900
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),

                                          title("Camión fecha llegada"),
                                          DateTimeField(
                                            label: carga.camion_fecha_llegada==null?"Selecciona una fecha":carga.camion_fecha_llegada,
                                            mode: DateFieldPickerMode.date,
                                            selectedDate: selectedDate,
                                            onDateSelected: (DateTime date) {
                                              setState(() {
                                                selectedDate = date;
                                                _camion_fecha_llegada= date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                                              });
                                            },//
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),

                                          title("Camión hora llegada"),
                                          DateTimeField(
                                            label: carga.camion_hora_llegada==null?"Selecciona una hora":carga.camion_hora_llegada,
                                            mode: DateFieldPickerMode.time,
                                            selectedDate: selectedDate5,
                                            onDateSelected: (DateTime date) {
                                              setState(() {
                                                selectedDate5 = date;
                                                var formattedTime = DateFormat('HH:mm').format(date);
                                                _hora_lelgada= formattedTime;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),

                                          title("Estiba hora llegada"),
                                          DateTimeField(
                                            label: carga.estiba_hora_llegada==null?"Selecciona una hora":carga.estiba_hora_llegada,
                                            mode: DateFieldPickerMode.time,
                                            selectedDate: selectedDate4,
                                            onDateSelected: (DateTime date) {
                                              setState(() {
                                                selectedDate4 = date;
                                                var formattedTime = DateFormat('HH:mm').format(date);
                                                _estiba_hora_llegada= formattedTime;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),

                                          title("Codigo asesor"),
                                          Form(
                                            // key: _formKey,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  hintText: carga.codigo_asesor
                                              ),
                                              obscureText: false,
                                              validator: (input)=> input.isEmpty ? 'Ingrese dato' : null,
                                              onChanged: (val){
                                                setState(() {
                                                  _ases_codigo=val;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),

                                          title("Asesoria fecha llegada"),
                                          DateTimeField(
                                            label: carga.asesoria_fecha_llegada==null?"Selecciona una fecha":carga.asesoria_fecha_llegada,
                                            mode: DateFieldPickerMode.date,
                                            selectedDate: selectedDate2,
                                            onDateSelected: (DateTime date) {
                                              setState(() {
                                                selectedDate2 = date;
                                                _ases_fecha_llegada=date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                                              });
                                            },

                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),

                                          title("Asesoria hora llegada"),
                                          DateTimeField(
                                            label: carga.asesoria_hora_llegada==null?"Selecciona una hora":carga.asesoria_hora_llegada,
                                            mode: DateFieldPickerMode.time,
                                            selectedDate: selectedDate3,
                                            onDateSelected: (DateTime date) {
                                              setState(() {
                                                selectedDate3 = date;
                                                var formattedTime = DateFormat('HH:mm').format(date);
                                                _ases_hora_llegada= formattedTime;
                                              });
                                            },

                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),

                                          title("Fecha inicio de carga"),
                                          DateTimeField(
                                            label: carga.fecha_inicio_carga==null?"Selecciona una fecha":carga.fecha_inicio_carga,
                                            mode: DateFieldPickerMode.date,
                                            selectedDate: selectedDate1,
                                            onDateSelected: (DateTime date) {
                                              setState(() {
                                                selectedDate1= date;
                                                _fecha_ini_carga= date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),

                                          title("Hora inicio de carga"),
                                          DateTimeField(
                                            label: carga.hora_inicio_carga==null?"Selecciona una hora":carga.hora_inicio_carga,
                                            mode: DateFieldPickerMode.time,
                                            selectedDate: selectedDate2,
                                            onDateSelected: (DateTime date) {
                                              setState(() {
                                                selectedDate2 = date;
                                                var formattedTime = DateFormat('HH:mm').format(date);
                                                _hora_ini_carga= formattedTime;
                                              });
                                            },
//
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),

                                          title("Fecha fin carga"),
                                          DateTimeField(
                                            label: carga.fecha_fin_carga==null?"Selecciona una fecha":carga.fecha_fin_carga,
                                            mode: DateFieldPickerMode.date,
                                            selectedDate: selectedDate3,
                                            onDateSelected: (DateTime date) {
                                              setState(() {
                                                selectedDate3 = date;
                                                _fecha_fin_carga= date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
                                              });
                                            },

                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),

                                          title( "Hora fin carga"),
                                          DateTimeField(
                                            label: carga.hora_fin_carga==null?"Selecciona una hora":carga.hora_fin_carga,
                                            mode: DateFieldPickerMode.time,
                                            selectedDate: selectedDate,
                                            onDateSelected: (DateTime date) {
                                              setState(() {
                                                selectedDate = date;
                                                var formattedTime = DateFormat('HH:mm').format(date);
                                                _hora_fin_carga= formattedTime;
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
                                                _setchanges(carga);

                                                CloudFirestoreAPI(docID: this.widget.docID).addData1(carga);

                                                Navigator.push(context,PageTransition(child: PhotoUpload(titulo: this.widget.titulo,docID: this.widget.docID,), type: PageTransitionType.rightToLeft));
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
                          )));
              }

            }),
    );


  }
}

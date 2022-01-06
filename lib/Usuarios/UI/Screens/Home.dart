import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qys/Usuarios/UI/Screens/login.dart';
import 'package:qys/Usuarios/bloc/bloc_user.dart';
import 'package:qys/Usuarios/model/carga.dart';
import 'package:qys/Usuarios/model/googlesheetscolumns.dart';
import 'package:qys/Usuarios/repository/cloud_firestore_api.dart';
import 'package:qys/Usuarios/repository/tottus_sheets_api.dart';
import 'package:qys/Widget/MyPreferences.dart';
import 'edit-ticket-1.dart';

class EditTicket extends StatefulWidget  {
  @override
  _EditTicketState createState() => _EditTicketState();

}

class _EditTicketState extends State<EditTicket> {
  UserBloc userBloc;
  String _nombreTienda = '';
  String _numeroTienda = '';
  MyPreferences _myPreferences = MyPreferences();

  Stream<QuerySnapshot> getRealTimeData() async* {
    Query query = FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('tickets').collection('pendientes');
    yield* query.snapshots(includeMetadataChanges: true);
  }

  Widget sindata(){
    return Center(
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset("assets/images/ticket.png"),
                Center(
                  child: Container(child: Text(
                    "Para agregar un nuevo ticket usa el boton '+' ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                      color: Color(0xFF9CA4AA),
                    ),
                  ),),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ) ,
          ),
        ],
      ),
    );
  }

  Widget tblTickets(){
    var Screenwidth=MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: getRealTimeData(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return sindata();
          }else{
            print('numero de tickets'+': '+snapshot.data.docs.length.toString());

            return  snapshot.data.docs.length>0?SingleChildScrollView(
                child: Container(
                  width: Screenwidth,
                  child: DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text("Tienda")),
                        DataColumn(label: Text("Numero")),
                        DataColumn(label: Text("Estado"))
                      ],
                      rows: _buildList(context, snapshot.data.docs)
                  ),
                ),
              )
                :sindata();
          }
        });
  }

  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return  snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot ticket) {
    String tit=ticket['tit_nombre']+'-'+ticket['tit_num'];
    String docid=ticket.id;

    return DataRow(
        onSelectChanged: (bool selected) {
          Navigator.push(context, PageTransition(child: EditTicketDetail (title: tit, docID: docid,), type: PageTransitionType.rightToLeft));
        },
        cells: [
      DataCell(
          Container(
            child: Text(ticket['tit_nombre'],overflow: TextOverflow.clip,),
          ),
        onLongPress: (){ _showModalButton(ticket.id); },
        onTap: (){Navigator.push(context, PageTransition(child: EditTicketDetail (title: tit, docID: docid,), type: PageTransitionType.rightToLeft));}
      ),
      DataCell(
          Text(ticket['tit_num']),),
      DataCell(
          Text(ticket['estado'].toString()),),
    ]);
  }

  _showModalButton(String name){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.edit),
                title: new Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  return _showDialog(context,"Editar Ticket",name);
                },
              ),
              ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Eliminar'),
                onTap: () {
                  CloudFirestoreAPI().pendientesDeleteTicket(name);
                  CloudFirestoreAPI().cargasDelete(name);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _showDialog(BuildContext ctx, String t,String name) {
    showDialog(context: ctx,
        builder: (context) {
          return AlertDialog(
              title: Center(
                  child:Text(t)),
              content: Container(
                height: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Text( "Nombre de tienda"+ ": ",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "BAHNSCHRIFT",
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Form(
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: " "
                        ),
                        obscureText: false,
                        validator: (input)=> input.isEmpty ? 'Ingrese nombre de tienda' : null,
                        onChanged: (val){
                          setState(() {
                            _nombreTienda=val;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text( "Número de tienda"+ ": ",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "BAHNSCHRIFT",
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Form(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: " "
                        ),
                        obscureText: false,
                        validator: (input)=> input.isEmpty ? 'Ingrese número de tienda' : null,
                        onChanged: (val){
                          setState(() {
                            _numeroTienda=val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: FlatButton(
                        color: Color.fromARGB(1000, 0, 104, 173),
                        child: Text(t=="Nuevo Ticket"?"Agregar":"Cambiar", style: TextStyle(color: Colors.white),),
                        onPressed: ()  {
                          Carga carga = new Carga(tit_nombre: _nombreTienda, tit_num: _numeroTienda);
                          t=="Nuevo Ticket"?CloudFirestoreAPI().addTicket(carga)
                              : CloudFirestoreAPI().editTicket(_nombreTienda, _numeroTienda,name);
                          // items.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ));
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: InkWell(
              onTap: (){
                // userBloc.signOut();
                Navigator.push(context,PageTransition(child: SignInScreen(), type: PageTransitionType.rightToLeft));
              },
              child: Icon(Icons.logout, color: Color.fromARGB(1000, 0, 104, 173),size: 24,)),
          title: Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Image.asset(
              'assets/images/logosinfondo.png',
              height: 60,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 15, 0 ),
              height: 35,
              width: 35,
              child: FloatingActionButton(
                backgroundColor:  Color.fromARGB(1000, 0, 104, 173),
                onPressed: () => setState(() {
                  _showDialog(context,"Nuevo Ticket","");
                }),
                // tooltip: 'Increment Counter',
                child: Icon(Icons.add,),
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(_myPreferences.uid).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData){
                return sindata();
              }
              else{
                var tienda = snapshot.data;
                _myPreferences.cliente = tienda["cliente"].toString();
                _myPreferences.commit();
                print(tienda["cliente"].toString());
                return tblTickets();
              }
            })
    );
  }

}
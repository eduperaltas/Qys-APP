import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qys/Usuarios/model/carga.dart';
import 'package:qys/Widget/MyPreferences.dart';

class CloudFirestoreAPI {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  MyPreferences _myPreferences = MyPreferences();
  String docID;

  CloudFirestoreAPI({this.docID});
  void addData1(Carga carga) async{

    // Call the user's CollectionReference to add a new user
    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(docID).update({

      //En EDIT TICKET 1
            if(carga.numero_TIM != null) 'numero TIM': carga.numero_TIM,
            if(carga.fecha_programacion != null) 'fecha programacion':carga.fecha_programacion,
            if(carga.empresa_de_transporte != null) 'empresa de transporte':carga.empresa_de_transporte,
            if(carga.origen != null) 'origen':carga.origen,
            if(carga.destino != null) 'destino':carga.destino,
            if(carga.tipo_de_carga != null) 'tipo de carga':carga.tipo_de_carga,
            if(carga.placa_carretera != null) 'placa carretera':carga.placa_carretera,
            if(carga.rampa != null) 'rampa':carga.rampa,
            if(carga.equipo_de_carga != null) 'equipo de carga':carga.equipo_de_carga,
            if(carga.camion_fecha_cita != null) 'camion fecha cita':carga.camion_fecha_cita,
            if(carga.camion_hora_cita != null) 'camion hora cita':carga.camion_hora_cita,

      //En EDIT TICKET 2
            if(carga.camion_fecha_llegada!=null) 'camion fecha llegada':carga.camion_fecha_llegada,
            if(carga.camion_hora_llegada!=null) 'camion hora llegada':carga.camion_hora_llegada,
            if(carga.estiba_hora_llegada!=null) 'estiba hora llegada':carga.estiba_hora_llegada,
            if(carga.codigo_asesor!=null) 'codigo asesor':carga.codigo_asesor,
            if(carga.asesoria_fecha_llegada!=null) 'asesoria fecha llegada':carga.asesoria_fecha_llegada,
            if(carga.asesoria_hora_llegada!=null) 'asesoria hora llegada':carga.asesoria_hora_llegada,
            if(carga.fecha_inicio_carga!=null) 'fecha inicio carga':carga.fecha_inicio_carga,
            if(carga.hora_inicio_carga!=null) 'hora inicio carga':carga.hora_inicio_carga,
            if(carga.hora_fin_carga!=null) 'hora fin carga':carga.hora_fin_carga,
            if(carga.fecha_fin_carga!=null) 'fecha fin carga':carga.fecha_fin_carga,


        });

    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('tickets').collection('pendientes').doc(docID).update({
      'estado': '10',
    });
  }

  Future<void> inicia_parada(int nparada,int Turno_inicio) async {
    var timekey = DateTime.now();

    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(docID).update({
        'estado':'parada',
        'N paradas':nparada,

      });

    return await FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids')
        .doc(docID).collection('paradas').doc(nparada.toString()).set({
        'inicio hora':timekey.hour.toString()+":"+timekey.minute.toString(),
        'inicio dia':timekey.day.toString()+"/"+timekey.month.toString()+"/"+timekey.year.toString(),
        'turno inicio':Turno_inicio,

        'fin dia':null,
        'fin hora':null,
        'turno fin': null,
        'motivo':null,
      });

  }

  Future<void>  terminar_parada(int nparada,String findia,String finhora,String motivo,int turno, String horaInicio, String fechaInicio)async{
    print('fin dia: '+nparada.toString());

    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(docID).update({
      'estado':'en proceso',
    });

    return await FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids')
        .doc(docID).collection('paradas').doc(nparada.toString()).update({
      'inicio dia':fechaInicio,
      'inicio hora':horaInicio,
      'fin dia':findia,
      'fin hora':finhora,
      'turno fin': turno,
      'motivo':motivo,
    });
  }

  Future<void>  guardar_parada(int nparada,String findia,String finhora,String motivo,int turno, String horaInicio, String fechaInicio)async{
    return await FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas')
        .collection('ids').doc(docID).collection('paradas').doc(nparada.toString()).update({
          if(fechaInicio!=null)'inicio dia':fechaInicio,
          if(horaInicio!=null)'inicio hora':horaInicio,
          if(findia!=null)'fin dia':findia,
          if(finhora!=null)'fin hora':finhora,
          if(turno!=null)'turno fin': turno,
          if(motivo!=null)'motivo':motivo,
        });
  }

  Future<void> pendientesDeleteTicket(String name) async {
     FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('tickets').collection('pendientes').doc(name).delete();
  }
  
  void cargasDelete(String name) async {
    //Elimino paradas
    var paradas = await FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas')
        .collection('ids').doc(name).collection('paradas').get();
    for (var doc in paradas.docs) {
      await doc.reference.delete();
    }
    //Elimino fotos
    var fotos = await FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas')
        .collection('ids').doc(name).collection('fotos').get();
    for (var doc in fotos.docs) {
      await doc.reference.delete();
    }
    //Elimino datos de carga
    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(name).delete();
  }

  //ADD CARGA

  void addTicket(Carga carga) async{
    var timekey = DateTime.now();

    var id = timekey.year.toString()+timekey.day.toString()+timekey.hour.toString()+timekey.second.toString()+timekey.millisecond.toString();

    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('usuarios').collection('supervisores').doc(_myPreferences.uid)
        .collection('cargas').doc(id).set({
       'inicio':timekey,
    });

    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(id).set({
      'user':_myPreferences.uid,
      'tit_nombre':carga.tit_nombre,
      'estado':'en proceso',
      'N paradas':0,
      'tit_num':carga.tit_num,
      'numero TIM': null,
      'fecha programacion':null,
      'empresa de transporte':null,
      'origen':null,
      'destino':null,
      'tipo de carga':null,
      'placa carretera':null,
      'rampa':null,
      'equipo de carga':null,
      'camion fecha cita':null,
      'camion hora cita':null,
      'camion fecha llegada':timekey.day.toString()+"/"+timekey.month.toString()+"/"+timekey.year.toString(),
      'camion hora llegada': timekey.hour.toString()+":"+timekey.minute.toString(),
      'ticket fecha creacion':timekey.day.toString()+"/"+timekey.month.toString()+"/"+timekey.year.toString(),
      'ticket hora creacion': timekey.hour.toString()+":"+timekey.minute.toString(),
      'estiba hora llegada':null,
      'codigo asesor':null,
      'asesoria fecha llegada':null,
      'asesoria hora llegada':null,
      'fecha inicio carga':timekey.day.toString()+"/"+timekey.month.toString()+"/"+timekey.year.toString(),
      'hora inicio carga': null,
      'hora fin carga':null,
      'fecha fin carga':null,
    });

    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('tickets').collection('pendientes').doc(id).set({
       'tit_nombre':carga.tit_nombre,
       'tit_num':carga.tit_num,
       'estado':'0',
       'user':_myPreferences.uid,
       'FechaHora': timekey,
     });

    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(id).collection('fotos').doc('1').set({
      'photoUrl1': null,
      'descripcion1': null,
      'photoUrl2': null,
      'descripcion2': null,
      'photoUrl3': null,
      'descripcion3': null,
      'photoUrl4': null,
      'descripcion4': null,
      'photoUrl5': null,
      'descripcion5': null,
      'photoUrl6': null,
      'descripcion6': null,
     });

  }

  //GET CARGA
  Carga _CargaDataFromSnapshot(DocumentSnapshot snapshot) {
      return Carga(
          tit_nombre: snapshot.data()['tit_nombre'],
          tit_num: snapshot.data()['tit_num'],
          ticket_fecha_creacion: snapshot.data()['ticket fecha creacion'],
          ticket_hora_creacion: snapshot.data()['ticket hora creacion'],
          user: snapshot.data()['user'],

          empresa_de_transporte: snapshot.data()['empresa de transporte'],
          camion_fecha_cita: snapshot.data()['camion fecha cita'],
          rampa: snapshot.data()['rampa'],
          equipo_de_carga: snapshot.data()['equipo de carga'],
          placa_carretera: snapshot.data()['placa carretera'],
          tipo_de_carga: snapshot.data()['tipo de carga'],
          destino: snapshot.data()['destino'],
          origen: snapshot.data()['origen'],
          numero_TIM: snapshot.data()['numero TIM'],
          camion_hora_cita: snapshot.data()['camion hora cita'],
          fecha_programacion: snapshot.data()['fecha programacion'],
          N_paradas: snapshot.data()['N paradas'],
          estado: snapshot.data()['estado'],

          camion_fecha_llegada: snapshot.data()['camion fecha llegada'],
          camion_hora_llegada: snapshot.data()['camion hora llegada'],
          estiba_hora_llegada: snapshot.data()['estiba hora llegada'],
          asesoria_fecha_llegada: snapshot.data()['asesoria fecha llegada'],
          asesoria_hora_llegada: snapshot.data()['asesoria hora llegada'],
          fecha_inicio_carga: snapshot.data()['fecha inicio carga'],
          hora_inicio_carga: snapshot.data()['hora inicio carga'],
          fecha_fin_carga: snapshot.data()['fecha fin carga'],
          hora_fin_carga: snapshot.data()['hora fin carga'],
          codigo_asesor: snapshot.data()['codigo asesor'],
      );

  }

  Stream<Carga> get cargaData {
    return FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(docID).snapshots()
        .map(_CargaDataFromSnapshot);
  }

  //EDIT Ticket
  void editTicket(String name,String num,String namedoc) async{
    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('tickets').collection('pendientes').doc(namedoc).update({
          'tit_nombre':name,
          'tit_num':num,
        });
    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(namedoc).update({
          'tit_nombre':name,
          'tit_num':num,
        });
  }

  //DELETE Ticket
  void deleteTicket(String name) async{
    var timekey = DateTime.now();
    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('tickets').collection('pendientes').doc(name).delete();
    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('usuarios').collection('supervisores')
        .doc(_myPreferences.uid).collection('cargas').doc(name).update({
      'Fecha fin Carga':timekey.day.toString()+"/"+timekey.month.toString()+"/"+timekey.year.toString(),
      'Hora fin Carga':timekey.hour.toString()+":"+timekey.minute.toString(),
    });
    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('tickets').collection('terminados').doc(name).set({
      'nombre':name,
      'user':_myPreferences.uid,
      'FechaHora': timekey,
    });
  }


  //createPhotoDocument
  void createPhotoDocument(String docName,String num,String url,String url2,String url3,String url4,String url5,String url6
      ,String f1,String f2,String f3,String f4, String f5, String f6) async{
    DocumentReference ref= FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(docName).collection('fotos').doc(num);
     ref.set({
      'photoUrl1': url,
      'descripcion1': f1,
      'photoUrl2': url2,
      'descripcion2': f2,
      'photoUrl3': url3,
      'descripcion3': f3,
      'photoUrl4': url4,
      'descripcion4': f4,
      'photoUrl5': url5,
      'descripcion5': f5,
      'photoUrl6': url6,
      'descripcion6': f6,
      'lastUpdate': DateTime.now(),
    });

     int estado=10*int.parse(num)+20;

    FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('tickets').collection('pendientes').doc(docName).update({
      'estado': estado.toString(),
    });
  }

}

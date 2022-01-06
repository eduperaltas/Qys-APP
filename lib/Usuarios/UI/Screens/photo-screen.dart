import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qys/Usuarios/UI/Screens/cargando.dart';
import 'package:qys/Usuarios/UI/Screens/Home.dart';
import 'package:qys/Usuarios/model/carga.dart';
import 'package:qys/Usuarios/model/fotos.dart';

import 'package:qys/Usuarios/model/googlesheetscolumns.dart';
import 'package:qys/Usuarios/repository/cloud_firestore_api.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:qys/Usuarios/repository/tottus_sheets_api.dart';
import 'package:qys/Widget/MyPreferences.dart';

class PhotoUpload extends StatefulWidget {
  String titulo, docID;
  PhotoUpload({this.titulo,this.docID});

  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  File img,img2,img3,img4,img5,img6;
  List<bool> f =[ false,  false,  false,  false,  false,  false, ];
  List<String> urls = [null, null, null, null, null, null,];
  List<String> descripciones = [null, null, null, null, null, null,];
  bool click_sig=false;
  bool click_fin=false;

  double TiempoTotalCarga = 0;

  Fotos fotos;
  double progress_F1=0;
  double progress_F2=0;
  double progress_F3=0;
  double progress_F4=0;
  double progress_F5=0;
  double progress_F6=0;
  int progCant=0;

  MyPreferences _myPreferences = MyPreferences();

  @override
  Widget build(BuildContext context) {

    return  StreamBuilder(
        stream: FirebaseFirestore.instance.collection(_myPreferences.cliente).doc('Cargas').collection('ids').doc(widget.docID).collection('fotos').doc('1').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasError){
            return Container(child: Center(child: Text(snapshot.error),),);
          }
          if(!snapshot.hasData){
            return loading();
          }else{
            var PhotoFromDB = snapshot.data;
            fotos= new Fotos(url1: PhotoFromDB["photoUrl1"],url2: PhotoFromDB["photoUrl2"],url3: PhotoFromDB["photoUrl3"],
                url4: PhotoFromDB["photoUrl4"],url5: PhotoFromDB["photoUrl5"],url6: PhotoFromDB["photoUrl6"],des1: PhotoFromDB["descripcion1"],
                des2: PhotoFromDB["descripcion2"],des3: PhotoFromDB["descripcion3"],des4: PhotoFromDB["descripcion4"],des5: PhotoFromDB["descripcion5"],
                des6: PhotoFromDB["descripcion6"]);

            return Screen();
          }
        });
  }

  Widget photo_container(int i){
    File img; String url;
    switch (i) {
      case 0:{ img = this.img; url = fotos.url1; } break;
      case 1:{ img = this.img2; url = fotos.url2; } break;
      case 2:{ img = this.img3; url = fotos.url3; } break;
      case 3:{ img = this.img4; url = fotos.url4; } break;
      case 4:{ img = this.img5; url = fotos.url5; } break;
      case 5:{ img = this.img6; url = fotos.url6; } break;
    }
    return GestureDetector(
      onTap:(){
        _showMyDialog((i+1).toString());
        setState(() {
          f[i] = true;
        });
      },
      child: Padding(
        padding:  const EdgeInsets.only(top: 10.0),
        child: Container(
          color: Colors.black12,
          child: img ==null ? url==null ? Icon(Icons.add): Form(

              child: Image.network(url,)
          ): Form(
              child: Image.file(img, fit: BoxFit.fill,)
          ),
        ),
      ),
    );
  }
  
  Widget Screen(){
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Color.fromARGB(1000, 0, 84, 173),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(24.0),
            child:Column(
              children: <Widget>[

              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0
                ),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index){
                  return photo_container(index);
                },
              ),

                SizedBox(height:20.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: fotos.des1==null?'Descripcion foto 1':fotos.des1,
                      ),
                      validator: (input)=> input.isEmpty ? 'Ingresa una descripcion' : null,
                      onChanged: (val){
                        setState(() => descripciones[0] = val);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: fotos.des2==null?'Descripcion foto 2':fotos.des2,
                      ),
                      validator: (input)=> input.isEmpty ? 'Ingresa una descripcion' : null,
                      onChanged: (val){
                        setState(() => descripciones[1] = val);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: fotos.des3==null?'Descripcion foto 3':fotos.des3,
                      ),
                      validator: (input)=> input.isEmpty ? 'Ingresa una descripcion' : null,
                      onChanged: (val){
                        setState(() => descripciones[2] = val);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: fotos.des4==null?'Descripcion foto 4':fotos.des4,
                      ),
                      validator: (input)=> input.isEmpty ? 'Ingresa una descripcion' : null,
                      onChanged: (val){
                        setState(() => descripciones[3]= val);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: fotos.des5==null?'Descripcion foto 5':fotos.des5,
                      ),
                      validator: (input)=> input.isEmpty ? 'Ingresa una descripcion' : null,
                      onChanged: (val){
                        setState(() => descripciones[4] = val);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: fotos.des6==null?'Descripcion foto 6':fotos.des6,
                      ),
                      validator: (input)=> input.isEmpty ? 'Ingresa una descripcion' : null,
                      onChanged: (val){
                        setState(() => descripciones[5] = val);
                      },
                    ),

                    SizedBox(height:10.0),

                    FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: Color.fromARGB(1000, 0, 84, 173),
                      onPressed: () async {
                        final Tottus = {
                          TottusFields.Foto1: fotos.url1,
                          TottusFields.Descripcion1: fotos.des1,
                          TottusFields.Foto2: fotos.url2,
                          TottusFields.Descripcion2: fotos.des2,
                          TottusFields.Foto3: fotos.url3,
                          TottusFields.Descripcion3: fotos.des3,
                          TottusFields.Foto4: fotos.url4,
                          TottusFields.Descripcion4: fotos.des4,
                          TottusFields.Foto5: fotos.url5,
                          TottusFields.Descripcion5: fotos.des5,
                          TottusFields.Foto6: fotos.url6,
                          TottusFields.Descripcion6: fotos.des6

                        };
                        await TottusSheetApi.update(widget.docID, Tottus);
                        setState(() {
                          click_sig = true;
                        });

                        return uploadPost(/*f1,f2,f3,f4,f5,f6*/);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: !click_sig?Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Guardar",
                              style: TextStyle(color: Colors.white, fontSize: 22.0,
                                  fontFamily: "BAHNSCHRIFT"),
                            ),
                            Icon(Icons.save, color: Colors.white,size: 32,)
                          ],
                        ):Column(
                          children: [
                          Text(
                            (((progress_F1/progCant)+(progress_F2/progCant)+(progress_F3/progCant)
                            +(progress_F4/progCant)+(progress_F5/progCant)+(progress_F6/progCant))).toStringAsFixed(2)+' %',
                            style: TextStyle(color: Colors.white, fontSize: 12.0,
                            fontFamily: "BAHNSCHRIFT"),textAlign: TextAlign.center,
                          ),
                            CupertinoProgressBar(
                              value: (((progress_F1/progCant)+(progress_F2/progCant)+(progress_F3/progCant)
                                  +(progress_F4/progCant)+(progress_F5/progCant)+(progress_F6/progCant)))/100,valueColor: Colors.white,
                            ),
                          ]
                        ),
                      ),
                    ),
                    SizedBox(height:10.0),
                    FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: Color.fromARGB(1000, 0, 84, 173),
                      onPressed: () async {
                        final Tottus = {
                          TottusFields.Foto1: fotos.url1,
                          TottusFields.Descripcion1: fotos.des1,
                          TottusFields.Foto2: fotos.url2,
                          TottusFields.Descripcion2: fotos.des2,
                          TottusFields.Foto3: fotos.url3,
                          TottusFields.Descripcion3: fotos.des3,
                          TottusFields.Foto4: fotos.url4,
                          TottusFields.Descripcion4: fotos.des4,
                          TottusFields.Foto5: fotos.url5,
                          TottusFields.Descripcion5: fotos.des5,
                          TottusFields.Foto6: fotos.url6,
                          TottusFields.Descripcion6: fotos.des6
                        };
                        await TottusSheetApi.update(widget.docID, Tottus);
                        if(_myPreferences.tim ==null){//CUADRAR VALIDACIONES
                          return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: ListTile(
                                title: Text('Error'),
                                subtitle: Text('Falta completar el dato TIM/OB'),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  color: Color.fromARGB(1000, 0, 84, 173),
                                  child: Text('Ok'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        }else{
                          print("paso");
                          setState(() {
                            click_sig = true;
                            click_fin = true;
                          });

                          return uploadPost();
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Finalizar",
                                style: TextStyle(color: Colors.white, fontSize: 22.0,
                                    fontFamily: "BAHNSCHRIFT"),
                              ),
                              Icon(Icons.navigate_next, color: Colors.white,size: 32,)
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }

  Future getImage(String f,ImageSource imgsrc) async {
    var tempImage = await ImagePicker().getImage(source: imgsrc, imageQuality: 40);
    setState(() {
      switch (f) {
        case "1": img = File(tempImage.path);
        break;
        case "2": img2 = File(tempImage.path);
        break;
        case "3": img3 = File(tempImage.path);
        break;
        case "4": img4 = File(tempImage.path);
        break;
        case "5": img5 = File(tempImage.path);
        break;
        case "6": img6 = File(tempImage.path);
        break;
      }
      progCant++;
    });
  }


  void uploadPost() async {
    //Subir imagen a firebase storage
    final firebase_storage.Reference postImageRef = firebase_storage.FirebaseStorage.instance
        .ref().child("prueba").child(_myPreferences.cliente).child(widget.docID);
    var timekey = DateTime.now();
    print('VALOR DE F1: ${f[0]}');
    File img;

    for(int i=0; i<f.length;i++){
      if( f[i] ){
        switch (i) {
          case 0:{ img = this.img ;} break;
          case 1:{ img = this.img2;} break;
          case 2:{ img = this.img3;} break;
          case 3:{ img = this.img4;} break;
          case 4:{ img = this.img5;} break;
          case 5:{ img = this.img6;} break;
        }
        final firebase_storage.UploadTask uploadTask =
        postImageRef.child("f${i}-"+timekey.toString() + ".jpg").putFile(img);

        uploadTask.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
          setState(() {
            progress_F1=(snapshot.bytesTransferred / snapshot.totalBytes)  * 100;
          });
        });

        var imageUrl = await(await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
        urls[i] = imageUrl.toString();
        print("Image url: " + urls[i]);
      }
    }
    //Guardar post a firebase database: database realtime
    saveToDatabase();

  }

  Widget btnOpcion(String txt, IconData icon, String f, ImageSource imgsrc, BuildContext ctx){
    return GestureDetector(
      onTap:(){
        getImage(f, imgsrc);
        Navigator.of(ctx).pop();
      },
      child: Padding(
        padding:  const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Icon(icon, size: 60,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(txt, style:
              TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: "BAHNSCHRIFT",
                fontSize: 16.0,
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String f) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, //e user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Imagen desde'),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                btnOpcion('Camara', Icons.camera_alt, f, ImageSource.camera, context),
                btnOpcion('Galeria', Icons.photo, f, ImageSource.gallery, context),
              ],
            ),
          ),
          actions: <Widget>[
          ],
        );
      },
    );
  }


  void saveToDatabase() {
    //SUBIDA DE URL DE FOTO A BD
    for(int i=0;i<6;i++){
      if(descripciones[i]=='null'){
        switch (i) {
          case 0: descripciones[i]=fotos.des1; break;
          case 1: descripciones[i]=fotos.des2; break;
          case 2: descripciones[i]=fotos.des3; break;
          case 3: descripciones[i]=fotos.des4; break;
          case 4: descripciones[i]=fotos.des5; break;
          case 5: descripciones[i]=fotos.des6; break;
        }
      }
    }

    CloudFirestoreAPI().createPhotoDocument(widget.docID,'1',urls[0],urls[1],urls[2],urls[3],urls[4],urls[5],
        descripciones[0],descripciones[1],descripciones[2],descripciones[3],descripciones[4],descripciones[5]) ;

    if(click_fin== true){
      CloudFirestoreAPI().deleteTicket(widget.docID);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTicket()),
    );
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

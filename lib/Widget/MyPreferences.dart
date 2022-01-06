import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences{
  static const  AUTOMATIC = "automatic";
  static const  UID = "uid";
  static const  TIM = "tim";
  static const  CLIENTE = "cliente";

  static final MyPreferences instance = MyPreferences._internal();


  //Campos a manejar
  SharedPreferences _sharedPreferences;
  bool automatic = true;
  String uid = "";
  String tim = "";
  String cliente = "";
  MyPreferences._internal(){

  }

  factory MyPreferences()=>instance;

  Future<SharedPreferences> get preferences async{
    if(_sharedPreferences != null){
      return _sharedPreferences;
    }else{
      _sharedPreferences = await SharedPreferences.getInstance();
      automatic = _sharedPreferences.getBool(AUTOMATIC);
      uid = _sharedPreferences.getString(UID);
      tim = _sharedPreferences.getString(TIM);
      cliente = _sharedPreferences.getString(CLIENTE);

      if(automatic == null){
        automatic = false;
        uid = "";
        tim = "";
        cliente = "";

      }
      return _sharedPreferences;

    }

  }
  Future<bool> commit() async {
    await _sharedPreferences.setBool(AUTOMATIC, automatic);
    await _sharedPreferences.setString(UID, uid);
    await _sharedPreferences.setString(TIM, tim);
    await _sharedPreferences.setString(CLIENTE, cliente);

  }

  Future<MyPreferences> init() async{
    _sharedPreferences = await preferences;
    return this;
  }


}
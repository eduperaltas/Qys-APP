import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';
import 'package:qys/Usuarios/model/googlesheetscolumns.dart';

class TottusSheetApi{
  static const _credentials = r'''
      {
      "type": "service_account",
  "project_id": "qysoperaciones",
  "private_key_id": "a4a88714b7b30cf6f136c6c7682b6432e3cafcd4",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCONXHIqHRv8ZKH\nyMqqlKiZ9KkV77dbaSbLRmZeXgF5+X8wMx/jcsEbOkP8PYR3xrWusC3hStPAPG4G\n8hUy5Zu5VHGNoZpvHiaNHVXNY0yg+3v1TUupiJz0Qbeg8D2Nl6u0/9oAUc4IFVVg\nIG7FNJMAkpzmd5kTEgyoeyTRcUGmlPuj9fOtr/a0kCxZT4hUOG4AZshEK8+AR5d6\nWDkHE9WCCGOHO+RBgN/G7OaUH2/9pbpNmR3Rwhzh/8E1375HCIRLte7Nyw1N1rNE\niCTT75hgnY3lYRLlNI4WckzCi4xi8nFt70Lm2BLlCEq1vy+LO0suHxnzqoe0oE0E\n0YRLqqLpAgMBAAECggEABRRbbJke+f9zrIr1BkCW5yAW/A20cgm6LrX+Iq4r6+3u\nZ5ij5No5k8RLuMV/wLSyn6GmYEig2KbjIGqV0qjitfnfFnm1WPVUPjBUJ/Wjv11/\ncRfvAghU4HqkDJXlAcFvPi29w5fCCrlF8+mLDo5qsJelqBIq8xEiR50ibjxXGOD/\nmvIQetSPSsaEPP7H+cS+NRS5jGW+cBDEjEn6I2Uiz6H6lgYsrjBgN5jbi/pZ9DSK\nUGHpam2MkVnPB3efqAP1p8wAW+D+f2UlblCv+RaAmEzFJfSL1ise9PLPCFguRu2k\nmIeXeUgaMI5QRP6u9sECVe3Ds8ON22FTrgXuIfWKqQKBgQDEwlwSo+7fBrU1nqSp\nZBLcz/prWwyRhmoEu7RAHiXgfdEI7V2WX5DmWUpB8xVuAD4rcPBdl4TrixhM+o35\nKOvezWJphRoAwI9gGW1U8KPfuAJoHwvaxrLLD8dQTfzQUFxhiR6tcU1rjm9RszG2\nsT8SWwCRkW94FU3pjcPQSgTgbQKBgQC5Bn3NvJjCGfIJhA/juPvTw8KRY9A/bfM/\nMA3+VlBY6LPTM9nf6hyBQYLvVvWFbxhvKsLSingYJJy4RyV3P9CXCnbkc2xtrOPC\n0V+GJjzOecKcNV3IcIJnftBu1vU5YwdpJSye2yZ48QjurLBGWycixgz/vyW+mt9m\nt+997eOW7QKBgQCK5YmJvyAJYPra9zrWOUb3ifoFfyjIMlL1NGxyNtYWO7ssyiOe\n26e2dKHvHGKsXI+GqxuDdkrm3DIzZUyD71dS2Tn3s3Y/wa9073420AlfDM7mIcSE\nlG/y2Riin+swQwpz8BAv8CPvIYWD7zPQ/B7CHmuwVzKRWri9fs4UY6w9oQKBgBIN\nOhTqg5TcZyragZpcH+WnQcJhlJ27onHVxGe+EBS8j17ZvjYEZ0eNFrM3LrkX/7BI\n4b0c2V6xo8Cu4E7kIPu7f6IGSNvidE47kzBJZsFWS9BlvIKjx3VFgBxwSHiS2tQ9\nVj8hbn16Nr7ihkg2+HiCDh6djZctEQK6i1kj7oJ5AoGBALdmvh7HKe6oa3mwU4ND\nuRHlklBfFBNbcWRryGgXv//kNqNAFdfXvRXLTS/3EwiHzZsgSGSoFcZOWcs/OH1J\neho2x4IoXk/vyE5moq65Zwfn7pHJkTGRo99MfYE12xiznpPDGO+n/kXmHh3gbOIX\nbEUQBuvEOD+l93Lvzu/FHAyw\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@qysoperaciones.iam.gserviceaccount.com",
  "client_id": "110382156163511279829",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40qysoperaciones.iam.gserviceaccount.com"
}
''';
  static final _spreadsheetId= "1AJQI14VFTNMLWTgOgUlUbLKuoh3xoY81sEBNb4bw3RI";
  static final _gsheets = GSheets(_credentials);
  static Worksheet   _TottusSheet;

  static Future init() async {
    try{
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _TottusSheet = await _getWorkSheet(spreadsheet, title:"Control de cargas");
      final firstRow = TottusFields.getFields();
      _TottusSheet.values.insertRow(1, firstRow);
    }
    catch (e){
      print("Init Error: $e");
    }
  }
  static Future<Worksheet> _getWorkSheet(
      Spreadsheet spreadsheet,{
        @required String title,
      }) async {
    try{
      return await spreadsheet.addWorksheet(title);
  } catch (e){
    return spreadsheet.worksheetByTitle(title) ;

  }
}
  static Future insert(List<Map<String, dynamic>> rowlist) async{
    if (_TottusSheet == null) return;
    _TottusSheet.values.map.appendRows(rowlist);
  }
  static Future<bool> update(
      String id,
      Map<String,dynamic> tottus,
      )async{
    if( _TottusSheet == null) return false;
    return _TottusSheet.values.map.insertRowByKey(id, tottus);

  }
}
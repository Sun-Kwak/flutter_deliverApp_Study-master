import 'package:flutter_deliverlyapp_test/common/const/data.dart';

class DataUtils{
  static String pathToUrl(String value){
    return 'http://$ip$value';
  }

  static List<String> listPathsToUrl(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }
}
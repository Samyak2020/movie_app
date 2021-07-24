import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';

class InternetConnectionUtils {

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a network.
        print("connected to internet");
           return true;
      } else {
        print("not connected to internet");
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }
}


final InternetConnectionUtils internetConnectionUtils = InternetConnectionUtils();
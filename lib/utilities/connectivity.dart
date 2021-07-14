import 'dart:io';

class InternetConnectionUtils{

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }else{
        print('not connected');
        return false;
      }
    }on SocketException catch (_) {
      print('not connected');
      return false;

    }
  }

}

final InternetConnectionUtils internetConnectionUtils = InternetConnectionUtils();
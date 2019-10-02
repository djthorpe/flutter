/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:shared_preferences/shared_preferences.dart';

/////////////////////////////////////////////////////////////////////

class Defaults {
  String _hostName = "";
  int _portNumber = 0;
  bool _secure = true;

  // METHODS ////////////////////////////////////////////////////////

  loadAll() async {
    var prefs = await SharedPreferences.getInstance();
    try {
      this._hostName = prefs.getString("hostName");
      this._portNumber = prefs.getInt("portNumber");
      this._secure = prefs.getBool("secure");
    } catch(_) {
      // Catch any errors with loading user preferences by clearing them out
      await this.removeAll();
    }
  }

  removeAll() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove("hostName");
      prefs.remove("portNumber");
      prefs.remove("secure");
      hostName = "";
      portNumber = 0;
      secure = true;
    });
  }

  // PROPERTIES /////////////////////////////////////////////////////

  String get hostName => this._hostName;
  set hostName(String value) {
    _hostName = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("hostName", _hostName);
    });
  }

  int get portNumber => this._portNumber;
  set portNumber(int value) {
    _portNumber = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("portNumber", _portNumber);
    });
  }

  bool get secure => this._secure;
  set secure(bool value) {
    _secure = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("secure", _secure);
    });
  }
}

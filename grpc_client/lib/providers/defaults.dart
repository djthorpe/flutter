/*
	gRPC Client
	Flutter client demonstrating communication with gRPC server
	Copyright (c) David Thorpe 2019
	Please see the LICENSE file for licensing information
*/

import 'package:shared_preferences/shared_preferences.dart';

/////////////////////////////////////////////////////////////////////

class Defaults {
  String _hostName;
  int _portNumber;
  bool _secure;

  // METHODS ////////////////////////////////////////////////////////

  loadAll() async {
    var prefs = await SharedPreferences.getInstance();
    this._hostName = prefs.getString("hostName");
    this._portNumber = prefs.getInt("portNumber");
    this._secure = true;
  }

  removeAll() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove("hostName");
      prefs.remove("portNumber");
      prefs.remove("secure");
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
      prefs.setInt("secure", _portNumber);
    });
  }
}

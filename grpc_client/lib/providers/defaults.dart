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

  loadAll() async {
    var prefs = await SharedPreferences.getInstance();
    this._hostName = prefs.getString("hostName");
    this._portNumber = prefs.getInt("portNumber");
  }

  removeAll() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove("hostName");
      prefs.remove("portNumber");
    });
  }

  String get hostName => this._hostName;
  set hostName(String value) {
    _hostName = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("hostName",_hostName);
    });
  }

  int get portNumber => this._portNumber;
  set portNumber(int value) {
    _portNumber = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt("portNumber",_portNumber);
    });
  }
}
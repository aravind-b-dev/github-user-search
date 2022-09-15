import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:skyislimit/view/searchResult.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        elevation: 2.0,
        title: const Text("Github User Search"),
        centerTitle: true,
      ),
      body: _connectionStatus.toString() == "ConnectivityResult.none"
          ? Center(
              child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                      "assets/images/12701-no-internet-connection.json"),
                ],
              ),
            ))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset("assets/images/"),
                Lottie.network(
                    'https://assets10.lottiefiles.com/packages/lf20_dK9q4K.json',
                    height: 150),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Username",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "OpenSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 15.7),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Container(
                              padding: const EdgeInsets.only(top: 0, left: 10),
                              width: MediaQuery.of(context).size.width * .8,
                              child: TextField(
                                controller: usernameController,
                                // controller: mobController,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  hintText: "Enter username",
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  // suffixIcon: Icon(Icons.arrow_forward_ios_sharp,size: 18,
                                  //   color: Colors.black,)
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 18.2, bottom: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchResult(
                                    name: usernameController.text,
                                  )));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .5,
                      height: 45.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(61),
                        ),
                        color: const Color(0xff235b5b),
                      ),
                      child: const Text("Search",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: "OpenSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.7),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

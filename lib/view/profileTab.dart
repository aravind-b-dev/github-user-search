import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:skyislimit/provider/profileProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab({this.name});
  String name;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Provider.of<SearchProvider>(context, listen: false)
        .searchUser(widget.name)
        .then((value) => null);

    super.initState();
  }

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
  Widget build(BuildContext context) {
    return _connectionStatus.toString() == "ConnectivityResult.none"
        ? Center(
            child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/images/12701-no-internet-connection.json"),
              ],
            ),
          ))
        : Container(
            color: Colors.blueGrey,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: Provider.of<SearchProvider>(context, listen: false)
                  .searchUser(widget.name),
              builder: (_, dataSnapShot) {
                if (dataSnapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (dataSnapShot.error != null) {
                    return Center(
                      child: Text("Something went wrong"),
                    );
                  } else {
                    return Consumer<SearchProvider>(
                      builder: (_, data, child) => Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 250,
                              width: 250,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  image: DecorationImage(
                                      image: NetworkImage(data.data.avatar_url),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              data.data.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              data.data.bio,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Repositories : ${data.data.public_repos}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 10),
                              child: TextButton(
                                onPressed: () => _launchUrl(data.data.url),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 220.6,
                                  height: 45.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(61),
                                    ),
                                    color: const Color(0xff235b5b),
                                  ),
                                  child: const Text("View Profile",
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
                      ),
                    );
                  }
                }
              },
            ),
          );
  }

  _launchUrl(profile) async {
    var url = profile;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:skyislimit/model/repositoryModel.dart';
import 'package:skyislimit/provider/profileProvider.dart';
import 'package:skyislimit/provider/repositoryProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryTab extends StatefulWidget {
  RepositoryTab({this.name});
  String name;

  @override
  State<RepositoryTab> createState() => _RepositoryTabState();
}

class _RepositoryTabState extends State<RepositoryTab> {
  @override
  void initState() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Provider.of<RepositoryProvider>(context, listen: false)
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
              future: Provider.of<RepositoryProvider>(context, listen: false)
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
                    return Consumer<RepositoryProvider>(
                      builder: (_, data, child) => Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  "${data.data.repository.length} repositories found ",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              data.data != null &&
                                      data.data.repository.length > 0
                                  ? ProductLists(
                                      details: data.data.repository,
                                    )
                                  : Container(
                                      height: 250,
                                      alignment: Alignment.center,
                                      child: const Text("No more Repo"),
                                    )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          );
  }
}

class ProductLists extends StatelessWidget {
  final List<ModelClassData> details;

  ProductLists({
    Key key,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 250,
      child: Column(
        children: List.generate(details.length, (index) {
          return ProductListaDatas(
            items: details[index],
          );
        }),
      ),
    );
  }
}

class ProductListaDatas extends StatefulWidget {
  final ModelClassData items;

  ProductListaDatas({
    Key key,
    this.items,
  }) : super(key: key);

  @override
  _ProductListaDatasState createState() => _ProductListaDatasState();
}

class _ProductListaDatasState extends State<ProductListaDatas> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        height: 120,
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(top: 2),
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                      image: NetworkImage(widget.items.avatar_url),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget.items.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Text(widget.items.full_name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 15)),
                  InkWell(
                    onTap: () => _launchUrl(),
                    child: Text(widget.items.html_url,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.blueGrey, fontSize: 15)),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  _launchUrl() async {
    var url = widget.items.html_url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skyislimit/provider/profileProvider.dart';
import 'package:skyislimit/provider/repositoryProvider.dart';
import 'package:skyislimit/view/landingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers :[
          ChangeNotifierProvider.value(value: SearchProvider()),
          ChangeNotifierProvider.value(value: RepositoryProvider()),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            return OrientationBuilder(
              builder: (context, orientation) {
                return MaterialApp(
                  title: 'Github Search',
                  home: MyHomePage(),
                  debugShowCheckedModeBanner: false,

                );
              },
            );
          },
        ),
      );
  }
}





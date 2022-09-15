import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:skyislimit/model/profileModel.dart';
import 'package:skyislimit/view/landingPage.dart';

class SearchProvider with ChangeNotifier {
  ProfileModel _fetchData;

  ProfileModel get data {
    return _fetchData;
  }
  BuildContext context;

  Future<Map<String, dynamic>> searchUser(username) async {
    Response res =
        await get(Uri.parse("https://api.github.com/users/$username"));

    var data = jsonDecode(res.body);

    log("------$data");

    if (data["login"] != null) {
      _fetchData = ProfileModel.fromJson(data);
    }
    else if (data["message"] == "Not Found") {
      print(data["message"]);
    }
    else {
      print("API rate limit exceeded for 157.46.219.16. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)");
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:skyislimit/model/repositoryModel.dart';


class RepositoryProvider with ChangeNotifier {

  RepositoryModel _fetchData;

  RepositoryModel get data {
    return _fetchData;
  }

  Future searchUser(username) async {
    Response res = await get(Uri.parse("https://api.github.com/users/$username/repos"));

    var  data = jsonDecode(res.body);

    // print("------${res.body}");

    _fetchData = RepositoryModel.fromJson(data);
  }
}
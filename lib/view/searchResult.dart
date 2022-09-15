

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skyislimit/provider/profileProvider.dart';
import 'package:skyislimit/view/profileTab.dart';
import 'package:skyislimit/view/repositoryTab.dart';

class SearchResult extends StatefulWidget {
  SearchResult({this.name});
  String name;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> with TickerProviderStateMixin{

  TabController _controller;

  @override
  void initState() {
    Provider.of<SearchProvider>(context, listen: false).searchUser(widget.name).then((value) => null);
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title:const Text("Search Result"),
        bottom: TabBar(
          controller: _controller,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.black,
          indicator: const BoxDecoration(
            border: const Border(
              bottom: BorderSide(color: Colors.white, width: 3.0),
            ),
          ),
          labelStyle:const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            const Tab(
              text: "Profile Tab",
            ),
            const Tab(
              text: "Repository",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          ProfileTab(
            name: widget.name,
          ),
          RepositoryTab(
            name: widget.name,
          )
        ],
      ),
    );
  }
}

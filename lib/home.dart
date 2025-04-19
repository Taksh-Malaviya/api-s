import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> data = [];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("API")),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(data[index]));
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CallingAPI();
          log(data.toString());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  //map
  Future<void> CallingAPI() async {
    var url = 'https://randomuser.me/api/?results=100';

    var res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var body = res.body;
      var json = jsonDecode(body);

      setState(() {
        data = List<String>.from(
          json['results'].map((e) => e['name']['first']),
        );
      });
    } else {
      log("Failed to load data: ${res.statusCode}");
    }
  }
}

// //list
//   Future<void> CallingAPI() async {
//     var url = "https://jsonplaceholder.typicode.com/posts";
//
//     var res = await http.get(Uri.parse(url));
//
//     var body = res.body;
//
//     var json = jsonDecode(body);
//     print(json);
//
//     setState(() {
//       data = List<String>.from(json.map((e) => e['title'].toString()));
//     });
//   }

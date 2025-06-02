import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List data = [];
String? car;
TextEditingController carController =
    TextEditingController(); // Controller for the text field

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Car Models API"),
        actions: [
          // Search TextField in the AppBar
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: carController, // Use controller to manage input
                decoration: const InputDecoration(
                  hintText: 'Search Car Model',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (value) {
                  setState(() {
                    car = value; // Get value when user submits the input
                  });
                  api(); // Fetch data based on the entered car model
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              log("Refreshing data...");
              api(); // Refresh the data
              log("Data reloaded");
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body:
          data.isEmpty
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Show loader while loading
              : ListView.separated(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.directions_car, size: 30),
                    title: Text(data[index]['model'] ?? 'No Model'),
                    subtitle: Text(data[index]['make'] ?? 'No Maker'),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            car = carController.text; // Get text from controller
          });
          api(); // Fetch data when the floating button is pressed
          log("Button Pressed: Data fetching");
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> api() async {
    if (car == null || car!.isEmpty) {
      log("Car model is empty, not fetching data.");
      return; // Don't fetch if no car model is provided
    }

    var uri = "https://api.api-ninjas.com/v1/cars?model=$car";

    try {
      var res = await http.get(
        Uri.parse(uri),
        headers: {'X-Api-Key': 'qdC72uM7zlm6pWDcpRBX3g==kemAmPNXLHvRGzkD'},
      );

      if (res.statusCode == 200) {
        var body = res.body;
        var json = jsonDecode(body);

        setState(() {
          data = List.from(json);
        });

        log("Data fetched successfully");
      } else {
        log("Error occurred: ${res.statusCode}");
      }
    } catch (e) {
      log("Exception: $e");
    }
  }
}

//list of countries
// Future<void> api() async {
//   log("Function run");
//   var url = 'https://restcountries.com/v3.1/all';
//
//   var res = await http.get(Uri.parse(url));
//
//   if (res.statusCode == 200) {
//     var body = res.body;
//
//     var json = jsonDecode(body);
//
//     setState(() {
//       data = List<String>.from(
//         json.map((e) => e['name']['common'].toString()),
//       );
//     });
//     log("Data arrived");
//   } else {
//     log("error occured ${res.statusCode}");
//   }
// }

//map
// Future<void> api() async {
//   var url = "https://dummyjson.com/products";
//
//   var res = await http.get(Uri.parse(url));
//
//   var body = res.body;
//
//   var json = jsonDecode(body);
//
//   setState(() {
//     data = json['products'];
//   });
// }

//Post
  void register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    String url = "http://localhost:4000/api/v1/auth/signup";
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        log("Registration successful: $data");
      } else {
        log("Registration failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("Error occurred: $e");
    }
  }

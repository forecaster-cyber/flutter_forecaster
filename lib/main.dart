import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml2json/xml2json.dart';

double tempe = 0;
String address = "";
final Xml2Json xml2Json = Xml2Json();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluuter Forecaster',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController lat = TextEditingController();
  TextEditingController lon = TextEditingController();
  void gg(String lat, String long) async {
    var latitude = lat;
    var longitude = long;
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=b0018ec0110b31b9c8778c2bdffc804f&units=metric'));

// Check the status code of the response to make sure it's successful
    if (response.statusCode == 200) {
      // Parse the response body as a JSON object
      var data = json.decode(response.body);

      // Extract the desired string from the data object
      double temp = data['main']['temp'];

      // Do something with the string
      print(temp);
      setState(() {
        tempe = temp;
      });
    } else {
      // Handle the error
      print('Request failed with status: ${response.statusCode}');
    }
    var address_response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude'));

// Check the status code of the response to make sure it's successful
    if (address_response.statusCode == 200) {
      // Parse the response body as a JSON object
      var address_data = address_response.body;
      xml2Json.parse(address_data);
      var jsonString = xml2Json.toParker();
      var final_address_data = json.decode(jsonString);
      print(final_address_data);

      // Extract the desired string from the data object
      String add = final_address_data['reversegeocode']['addressparts']['city'];

      // Do something with the string
      print(add);
      setState(() {
        address = add;
      });
    } else {
      // Handle the error
      print('Request failed with status: ${response.statusCode}');
    }
  }

  void _incrementCounter() {
    setState(() {
      gg(lat.text, lon.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(address.toString()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: TextField(
                  controller: lat,
                  decoration: InputDecoration(labelText: "enter latitude"),
                ),
                width: 400,
                height: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: TextField(
                  controller: lon,
                  decoration: InputDecoration(labelText: "enter longitude"),
                ),
                width: 400,
                height: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$tempe'+'°',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

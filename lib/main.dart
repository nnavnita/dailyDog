import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get('https://dog.ceo/api/breeds/image/random');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String message, status;

  Album({this.message, this.status});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      message: json['message'],
      status: json['status'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

Map<int, Color> redChalk = {
  50: Color.fromRGBO(240, 120, 120, .1),
  100: Color.fromRGBO(240, 120, 120, .2),
  200: Color.fromRGBO(240, 120, 120, .3),
  300: Color.fromRGBO(240, 120, 120, .4),
  400: Color.fromRGBO(240, 120, 120, .5),
  500: Color.fromRGBO(240, 120, 120, .6),
  600: Color.fromRGBO(240, 120, 120, .7),
  700: Color.fromRGBO(240, 120, 120, .8),
  800: Color.fromRGBO(240, 120, 120, .9),
  900: Color.fromRGBO(240, 120, 120, 1),
};

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  void handleTap() {
    setState(() {
      futureAlbum = fetchAlbum();
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = 'Random Dog';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFf07878, redChalk),
      ),
      home: Scaffold(
        backgroundColor: Color(0xFF90d8c0),
        appBar: AppBar(title: Text(title, style: TextStyle(fontSize: 40))),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return InkWell(
                    onTap: handleTap,
                    child: Container(
                        width: 300.0,
                        height: 300.0,
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new NetworkImage(snapshot.data.message),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(50.0)),
                            border: new Border.all(
                              color: MaterialColor(0xFFf07878, redChalk),
                              width: 10.0,
                            ))));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

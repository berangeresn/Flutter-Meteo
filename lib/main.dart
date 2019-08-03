import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Météo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: MyHomePage(title: 'Flutter Météo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> cities = ["Paris", "Le Mans", "Rennes"];

  String selectedCity;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.lightBlueAccent,
          child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(
                      cities[i]),
                  onTap: () {
                    setState(() {
                      selectedCity = cities[i];
                      Navigator.pop(context);
                    });
                  },
                );
              }),
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Text(
              (selectedCity == null) ? "Ville actuelle" : selectedCity),
        ),
      );
  }
}

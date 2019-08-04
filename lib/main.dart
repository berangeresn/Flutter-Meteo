import 'package:flutter/material.dart';
import 'package:flutter_meteo/widgets/custom_text.dart';
import 'package:async/async.dart';


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
              itemCount: cities.length + 2,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CustomText("Mes villes", fontSize: 22.0,),
                        RaisedButton(
                          onPressed: addCity,
                            child: CustomText("Ajouter une ville", color: Colors.blue, fontSize: 15.0,),
                          color: Colors.white,
                          shape: StadiumBorder(),
                          elevation: 8.0,
                          ),
                      ],
                    ),
                  );
                } else if (i == 1) {
                  return ListTile(
                    title: CustomText("Ma ville actuelle"),
                    onTap: () {
                      setState(() {
                        selectedCity = null;
                        Navigator.pop(context);
                      });
                    },
                  );
                } else {
                  String city = cities[i - 2];
                  return ListTile(
                    title: CustomText(
                        city),
                    onTap: () {
                      setState(() {
                        selectedCity = city;
                        Navigator.pop(context);
                      });
                    },
                  );
                }
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

  Future<Null> addCity() async {
    return showDialog(
      barrierDismissible: true,
        builder: (BuildContext buildContext) {
            return SimpleDialog(
              contentPadding: EdgeInsets.all(20.0),
              shape: UnderlineInputBorder(),
              title: CustomText("Ajouter une ville", fontSize: 22.0, color: Colors.blue,),
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: "Ville : ",
                  ),
                  onSubmitted: (String str) {
                    Navigator.pop(buildContext);
                  },
                )
              ],
            );
        },
        context: context,
    );
  }

}

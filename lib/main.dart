import 'package:flutter/material.dart';
import 'package:flutter_meteo/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';



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

  String key = "villes";

  List<String> cities = [];

  String selectedCity;

  @override
  void initState() {
    super.initState();
    getCities();
  }

  @override
  Widget build(BuildContext context) {
/// Create Drawer with a selection of cities
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

  /// To add a city in the Drawer
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
                    addCities(str);
                    Navigator.pop(buildContext);
                  },
                )
              ],
            );
        },
        context: context,
    );
  }

  /// A function with shared preferences
  void getCities() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> liste = await sharedPreferences.getStringList(key);
    if (liste != null) {
      setState(() {
        cities = liste;
      });
    }
  }

  /// A function to add a city with shared preferences
 void addCities(String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    cities.add(str);
    await sharedPreferences.setStringList(key, cities);
    getCities();
 }

}

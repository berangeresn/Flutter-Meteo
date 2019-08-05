import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meteo/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'temperature.dart';
import 'dart:convert';
import 'my_flutter_app_icons.dart';


void main() {
  /// App in portrait orientation only - with services.dart
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

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
  Coordinates coordsSelectedCity;
  Temperature temperature;
  String currentName = "Ville actuelle";

  AssetImage night = AssetImage("assets/night.jpg");
  AssetImage sun = AssetImage("assets/day.jpg");
  AssetImage rain = AssetImage("assets/rain.jpg");
  AssetImage cloud = AssetImage("assets/cloud.jpg");
  AssetImage snow = AssetImage("assets/snow1.jpg");
  AssetImage storm = AssetImage("assets/storm.jpg");
  AssetImage mist = AssetImage("assets/mist.jpg");

  /// Location of the user
  Location location;
  LocationData locationData;
  Stream<LocationData> stream;


  @override
  void initState() {
    super.initState();
    getCities();
    location = new Location();
    //getFirstLocation();
    listenToStream();
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
                    title: CustomText(currentName),
                    onTap: () {
                      setState(() {
                        selectedCity = null;
                        coordsSelectedCity = null;
                        callApi();
                        Navigator.pop(context);
                      });
                    },
                  );
                } else {
                  String city = cities[i - 2];
                  return ListTile(
                    title: CustomText(
                        city),
                    trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.white,),
                        onPressed: () {
                          deleteCity(city);
                        }),
                    onTap: () {
                      setState(() {
                        selectedCity = city;
                        coordsFromCity();
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
      body: (temperature == null)
          ? Center(child: Text((selectedCity == null) ? currentName : selectedCity))
          : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: getBackground(), fit: BoxFit.cover,)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CustomText((selectedCity == null) ? currentName : selectedCity, fontSize: 40.0, color: Colors.white,),
            CustomText(temperature.description, fontSize: 25.0, color: Colors.white, fontStyle: FontStyle.italic,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.network("http://openweathermap.org/img/wn/${temperature.icon}@2x.png"),
                CustomText("${temperature.temp.toInt()}°C", color: Colors.white, fontSize: 68.0,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                extra("${temperature.tempMin.toInt()}°C", MyFlutterApp.down),
                extra("${temperature.tempMax.toInt()}°C", MyFlutterApp.up),
                extra("${temperature.pressure.toInt()}", MyFlutterApp.temperatire),
                extra("${temperature.humidity.toInt()}%", MyFlutterApp.rain)
              ],
            ),
          ],
        ),
      )
      );
  }

  /// A column for flutter icons
  Column extra(String data, IconData iconData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(iconData, color: Colors.white, size: 28.0,),
        CustomText(data)
      ],
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

 /// Delete a city with shared preferences
  void deleteCity(String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    cities.remove(str);
    await sharedPreferences.setStringList(key, cities);
    getCities();
  }

  /// Background images
  AssetImage getBackground() {
    if (temperature.icon.contains("n")) {
      return night;
    } else if ((temperature.icon.contains("01d")) || (temperature.icon.contains("02d"))) {
      return sun;
    } else if ((temperature.icon.contains("03d")) || (temperature.icon.contains("04d"))) {
      return cloud;
    } else if ((temperature.icon.contains("09d")) || (temperature.icon.contains("10d"))) {
      return rain;
    } else if (temperature.icon.contains("13d")) {
      return snow;
    } else if (temperature.icon.contains("50d")) {
      return mist;
    }
  }

  /// Get User Location
  getFirstLocation() async {
    try {
      locationData = await location.getLocation();
      print("Nouvelle position : ${locationData.latitude} / ${locationData.longitude}");
      locationToString();
    } catch (e) {
      print("Erreur : $e");
    }
  }

  /// Récupérer le flux de données
  /// Each change of location
  listenToStream() {
    stream = location.onLocationChanged();
    stream.listen((newPosition) {
      if ((locationData == null) || (newPosition.longitude != locationData.longitude) && (newPosition.latitude != locationData.latitude)) {
        /// Get locality name
        setState(() {
          print("New position : ${newPosition.latitude} / ${newPosition.longitude}");
          locationData = newPosition;
          locationToString();
        });
      }
    });
  }

  /// Geocoder : forward and reverse geocoding
  locationToString() async {
    if (locationData != null) {
      Coordinates coordinates = new Coordinates(locationData.latitude, locationData.longitude);
      /// Get a city name
      final cityName = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      setState(() {
        currentName = cityName.first.locality;
        callApi();
      });
    }
  }

  /// Convert a city to its coordinates
  coordsFromCity() async {
    if (selectedCity != null) {
      List<Address> addresses = await Geocoder.local.findAddressesFromQuery(selectedCity);
      if (addresses.length > 0) {
        Address first = addresses.first;
        Coordinates coords = first.coordinates;
        setState(() {
          coordsSelectedCity = coords;
          callApi();
        });
      }
    }
  }

   callApi() async {
    double lat;
    double lon;
    /// if we've got first coordinates
    if (coordsSelectedCity != null) {
      lat = coordsSelectedCity.latitude;
      lon = coordsSelectedCity.longitude;
    } else if (locationData != null) {
      lat = locationData.latitude;
      lon = locationData.longitude;
    }

    if (lat != null && lon != null) {
      final key = "&APPID=1c144073c12f04975bee36e075109240";
      /// get the language code
      String lang = "&lang=${Localizations.localeOf(context).languageCode}";
      String baseAPI = "http://api.openweathermap.org/data/2.5/weather?";
      String coordsString = "lat=$lat&lon=$lon";
      String units = "&units=metric";
      String totalString = baseAPI + coordsString + units + lang + key;
      final response = await http.get(totalString);
      if (response.statusCode == 200) {
        /// convert json format
        Map map = json.decode(response.body);
        setState(() {
          temperature = Temperature(map);
        });
      } else {
        print(response.statusCode);
      }
    }
  }

}

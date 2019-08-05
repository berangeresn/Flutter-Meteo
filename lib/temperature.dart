
class Temperature {

  String main;
  String description;
  String icon;
  var temp;
  var pressure;
  var humidity;
  var tempMin;
  var tempMax;
  var speed;
  var deg;


  Temperature(Map map) {
    List weather = map["weather"];
    /// We've got the first element of "weather"
    Map weatherMap = weather.first;
    this.main = weatherMap["main"];
    this.description = weatherMap["description"];
    this.icon = weatherMap["icon"];

    Map mainMap = map["main"];
    this.temp = mainMap["temp"];
    this.pressure = mainMap["pressure"];
    this.humidity = mainMap["humidity"];
    this.tempMin = mainMap["temp_min"];
    this.tempMax = mainMap["temp_max"];

    Map windMap = map["wind"];
    this.speed = windMap["speed"];
    this.deg = windMap["deg"];
  }
}
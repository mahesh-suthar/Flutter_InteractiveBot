import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  String apiId = '3bd66683e70331ab14f35fc2b6bfd008';
  Future<WeatherModel> fetchWeather(String city) async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      WeatherModel weatherInfo = WeatherModel.fromJson(result);

      return weatherInfo;
    } else {
      throw 'Error';
    }
  }
}

class WeatherModel {
  int id;
  int humidity;
  String country;
  String name;
  String description;
  double speed;
  double temp;

  WeatherModel({
    required this.id,
    required this.country,
    required this.description,
    required this.name,
    required this.speed,
    required this.temp,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        id: json["weather"][0]["id"],
        country: json["sys"]["country"],
        description: json["weather"][0]["description"],
        name: json["name"],
        speed: json["wind"]["speed"],
        temp: json["main"]["temp_min"],
        humidity: json["main"]["humidity"],
      );
}

class WeatherController extends GetxController {
  var weather = WeatherModel(
    id: 0,
    description: '',
    country: '',
    name: '',
    speed: 0,
    temp: 0,
    humidity: 0,
  ).obs;
  final city = [
    'Jakarta',
    'Semarang',
    'Tangerang',
    'Aceh',
    'Malang',
    'Bekasi',
    'Padang',
  ];
  var cityValue = 'Jakarta'.obs;
  final _weatherIconList = [
    'https://assets9.lottiefiles.com/temp/lf20_XkF78Y.json', //thunderstorm
    'https://assets9.lottiefiles.com/temp/lf20_rpC1Rd.json', //rain
    'https://assets9.lottiefiles.com/temp/lf20_BSVgyt.json', //snow
    'https://assets9.lottiefiles.com/temp/lf20_HflU56.json', //many circumstance
    'https://assets9.lottiefiles.com/temp/lf20_Stdaec.json', //clear
    'https://assets9.lottiefiles.com/temp/lf20_dgjK9i.json', //Cloudy
  ];
  var weatherIcon = ''.obs;

  var isLoading = true.obs;

  @override
  onInit() {
    super.onInit();
    fetchWeather(cityValue.value);
  }

  Future fetchWeather(String city) async {
    isLoading.value = true;
    try {
      var _weatherInfo = await WeatherService().fetchWeather(city);
      weather.value = _weatherInfo;
      fetchWeatherIcon();
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  Future fetchWeatherIcon() async {
    var weatherId = await weather.value.id;
    if (weatherId < 299) {
      weatherIcon.value = _weatherIconList[0];
    } else if (weatherId < 532) {
      weatherIcon.value = _weatherIconList[1];
    } else if (weatherId < 622) {
      weatherIcon.value = _weatherIconList[2];
    } else if (weatherId < 781) {
      weatherIcon.value = _weatherIconList[3];
    } else if (weatherId == 800) {
      weatherIcon.value = _weatherIconList[4];
    } else if (weatherId > 800) {
      weatherIcon.value = _weatherIconList[5];
    }
  }
}

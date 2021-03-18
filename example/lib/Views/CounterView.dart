import 'package:example/Request/Request.dart';
import 'package:flutter/material.dart';
import '../Models/CounterModel.dart';
import 'package:mc/mc.dart';

class CounterExample extends StatelessWidget {
  final String title;
  final MyModel adn = MyModel();
  CounterExample({this.title});
  final Counter counter = Counter();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            McView(
              model: counter,
              builder: (BuildContext context, Widget child) {
                return Text(
                  counter.count.toString(),
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        //change your field by json structure
        onPressed: () {
          adReq
              .getObjData("v1/calendar", adn,
                  params: {
                    "latitude": "51.508515",
                    "longitude": "-0.1254872",
                    "method": "2",
                    "month": "4",
                    "year": "2017"
                  },
                  path: "[data/{timings")
              .then((value) => print(value.Asr));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class MyModel extends McModel {
  String Fajr;
  String Sunrise;
  String Dhuhr;
  String Asr;
  String Sunset;
  String Maghrib;
  String Isha;
  String Imsak;
  String Midnight;

  MyModel({
    this.Fajr,
    this.Sunrise,
    this.Dhuhr,
    this.Asr,
    this.Sunset,
    this.Maghrib,
    this.Isha,
    this.Imsak,
    this.Midnight,
  });
  fromJson(Map<String, dynamic> json) {
    Fajr = json['Fajr'] ?? Fajr;
    Sunrise = json['Sunrise'] ?? Sunrise;
    Dhuhr = json['Dhuhr'] ?? Dhuhr;
    Asr = json['Asr'] ?? Asr;
    Sunset = json['Sunset'] ?? Sunset;
    Maghrib = json['Maghrib'] ?? Maghrib;
    Isha = json['Isha'] ?? Isha;
    Imsak = json['Imsak'] ?? Imsak;
    Midnight = json['Midnight'] ?? Midnight;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Fajr'] = this.Fajr;
    data['Sunrise'] = this.Sunrise;
    data['Dhuhr'] = this.Dhuhr;
    data['Asr'] = this.Asr;
    data['Sunset'] = this.Sunset;
    data['Maghrib'] = this.Maghrib;
    data['Isha'] = this.Isha;
    data['Imsak'] = this.Imsak;
    data['Midnight'] = this.Midnight;

    return data;
  }
}

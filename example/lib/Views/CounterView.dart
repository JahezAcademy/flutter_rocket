import 'package:example/Request/Request.dart';
import 'package:flutter/material.dart';
import '../Models/CounterModel.dart';
import 'package:mc/mc.dart';

class CounterExample extends StatelessWidget {
  final String title;
  final Product adn = Product();
  CounterExample({this.title});
  final Counter counter = Counter();
  int count = 0;
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
          counter.fromJson({"count": count++});
          adReq
              .getObjData("ApiEcommerceApp/items", adn,
                  multi: true, params: {'limit': "2"}, path: "[results/")
              .then((value) => print(value[0].price));
          //////////
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Product extends McModel {
  List multi;
  int id;
  String title;
  String ar_title;
  double price;
  String store;
  String description;
  String ar_description;
  String image;
  int quantity_total;

  Product({
    this.id,
    this.title,
    this.ar_title,
    this.price,
    this.store,
    this.description,
    this.ar_description,
    this.image,
    this.quantity_total,
  }) {
    multi = multi ?? [];
  }
  fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? id;
    title = json['title'] ?? title;
    ar_title = json['ar_title'] ?? ar_title;
    price = json['price'] ?? price;
    store = json['store'] ?? store;
    description = json['description'] ?? description;
    ar_description = json['ar_description'] ?? ar_description;
    image = json['image'] ?? image;
    quantity_total = json['quantity_total'] ?? quantity_total;
    return super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['ar_title'] = this.ar_title;
    data['price'] = this.price;
    data['store'] = this.store;
    data['description'] = this.description;
    data['ar_description'] = this.ar_description;
    data['image'] = this.image;
    data['quantity_total'] = this.quantity_total;

    return data;
  }

  void setMulti(List d) {
    List r = d.map((e) {
      Product m = Product();
      m.fromJson(e);
      return m;
    }).toList();
    print(d);
    multi = r;
  }
}

//Controller of your main model
//if you need more controller you can copy this and use it

class ProductC {
  static final ProductC _productC = ProductC._internal();
  Product product = Product();
  factory ProductC() {
    return _productC;
  }
  //you can add more methods
  //any action on multi list you need to call rebuild method for rebuild widgets
  ProductC._internal();
}

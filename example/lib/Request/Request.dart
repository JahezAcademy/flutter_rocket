import 'package:mc/mc.dart';

//your url without http or https and also without any /
String baseUrl = 'jsonplaceholder.typicode.com';

McRequest request = McRequest(url: baseUrl);
String yu = "medpy.pythonanywhere.com";
String token = "4acabed770cf8da7509cfaa65769d98b0cc6d20b";
Map<String, String> apiHeaders = {
  "Authorization": "Token " + token,
  "Content-Type": "application/json",
  "Accept": "application/json, text/plain, */*",
  "X-Requested-With": "XMLHttpRequest",
};
McRequest adReq = McRequest(url: yu,headers: apiHeaders);



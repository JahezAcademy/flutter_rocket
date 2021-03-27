import 'package:mc/mc.dart';

//your url without http or https and also without any /
String baseUrl = 'jsonplaceholder.typicode.com';
String token = "4acabed770cf............................";

Map<String, String> apiHeaders = {
  "Authorization": "Token " + token,
  "Content-Type": "application/json",
  "Accept": "application/json, text/plain, */*",
  "X-Requested-With": "XMLHttpRequest",
};

McRequest request = McRequest(url: baseUrl);

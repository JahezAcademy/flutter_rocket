import 'package:mc/mc.dart';

//your url without http or https and also without any /
String baseUrl = 'jsonplaceholder.typicode.com';

McRequest request = McRequest(url: baseUrl);

String adhan = "api.aladhan.com";
McRequest adReq = McRequest(url: adhan);

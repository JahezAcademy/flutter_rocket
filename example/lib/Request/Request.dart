import 'package:mc/mc.dart';

//your url without http or https and also without any /

const String url = "http://192.168.1.113:8000";
const String token = "67d69ec62699cd1c6214813df2c8600f2e14271d";
const Map<String, String> apiHeaders = {
  "Authorization": "Token " + token,
  "Content-Type": "application/json",
  "Accept": "application/json, text/plain, */*",
  "X-Requested-With": "XMLHttpRequest",
};
McRequest rq = McRequest(url: url, headers: apiHeaders);


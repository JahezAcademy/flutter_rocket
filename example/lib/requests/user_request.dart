import 'package:example/models/user_model.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

const String usersEndpoint = "users";

class GetUsers {
  static Future getUsers(User userModel) => RocketController()
      .get<RocketRequest>(mcRequestKey)
      .getObjData(usersEndpoint, userModel, multi: true);
}
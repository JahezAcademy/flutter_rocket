import 'package:example/models/user_model.dart';
import 'package:flutter_rocket/rocket.dart';

const String usersEndpoint = "users";

class GetUsers {
  static Future getUsers(User userModel) =>
      Rocket.get<RocketClient>().request(usersEndpoint, model: userModel);
}

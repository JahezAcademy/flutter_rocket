import 'package:example/models/user_model.dart';

import 'request.dart';

const String usersEndpoint = "users";

class GetUsers {
  static Future getUsers(User userModel) =>
      baseRequest.request(usersEndpoint, model: userModel);
}

import 'package:example/models/user_model.dart';
import 'package:mc/mc.dart';

const String usersEndpoint = "users";

class GetUsers {
  static Future getUsers(User userModel) => McController()
      .get<McRequest>(mcRequestKey)
      .getObjData(usersEndpoint, userModel, multi: true);
}

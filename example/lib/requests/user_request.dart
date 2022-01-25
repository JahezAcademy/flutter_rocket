import 'package:example/models/user_model.dart';
import 'package:mc/mc.dart';

class GetUsers {
  static Future getUsers(User user) => McController()
      .get<McRequest>('rq')
      .getObjData("users", user, multi: true);
}

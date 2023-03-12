import 'package:example/models/todos.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

const String todosEndpoint = "todos";

class GetTodos {
  static Future gettodos(Todos todosModel) =>
      Rocket.get<RocketRequest>(rocketRequestKey)
          .request(todosEndpoint, model: todosModel);
}

import 'package:example/models/todo.dart';
import 'package:mvc_rocket/mvc_rocket.dart';

const String todosEndpoint = "todos";

class GetTodos {
  static Future getTodos(Todos todosModel) =>
      Rocket.get<RocketRequest>(rocketRequestKey)
          .request(todosEndpoint, model: todosModel);
}

import 'package:rocket_cli/rocket_cli.dart';

void main(List<String> arguments) {
  Generator gen = Generator();
  ModelsController controller = ModelsController();
  gen.generate('{"name":"John Doe","age":30,"cars":[{"hello":"World"}]}',
      "Person", controller);
  for (var model in controller.models) {
    print(model.name);
    print(model.result);
  }
}

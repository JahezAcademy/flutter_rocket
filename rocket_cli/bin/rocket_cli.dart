import 'package:rocket_cli/rocket_cli.dart';

void main(List<String> arguments) {
  Generator gen = Generator();
  ModelsController models = gen.generate(
      '{"name":"John Doe","age":30,"cars":[{"hello":"World"}]}', "Person");
  print(models.models);
}

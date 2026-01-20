import 'dart:io';
import 'package:args/args.dart';
import 'package:rocket_cli/rocket_cli.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('json', abbr: 'j', help: 'Raw JSON string')
    ..addOption('file', abbr: 'f', help: 'Path to JSON file')
    ..addOption('name', abbr: 'n', help: 'Class name', defaultsTo: 'MyModel')
    ..addOption('output',
        abbr: 'o', help: 'Output directory', defaultsTo: 'lib/models')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    print(e);
    print(parser.usage);
    return;
  }

  if (argResults['help']) {
    print('Rocket CLI - Model Generator');
    print(parser.usage);
    return;
  }

  String? jsonContent;

  if (argResults['json'] != null) {
    jsonContent = argResults['json'];
  } else if (argResults['file'] != null) {
    final file = File(argResults['file']);
    if (!await file.exists()) {
      print('Error: File not found at ${argResults['file']}');
      return;
    }
    jsonContent = await file.readAsString();
  } else {
    print('Error: You must provide either --json or --file');
    print(parser.usage);
    return;
  }

  final String className = argResults['name'];
  final String outputDir = argResults['output'];

  final Generator gen = Generator();
  final ModelsController controller = ModelsController();

  try {
    await gen.generate(jsonContent!, className, controller);
  } catch (e) {
    print('Error during generation: $e');
    return;
  }

  if (controller.models.isEmpty) {
    print('No models generated.');
    return;
  }

  final directory = Directory(outputDir);
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  for (var model in controller.models) {
    // Generate filename from class name (camelCase to snake_case)
    String fileName = model.name
        .replaceAllMapped(
            RegExp(r'([a-z0-9])([A-Z])'), (Match m) => '${m[1]}_${m[2]}')
        .toLowerCase();

    final file = File('${directory.path}/$fileName.dart');
    await file.writeAsString(model.result);
    print('✅ Generated: ${file.path}');
  }

  print(
      '\nSuccess! ${controller.models.length} model(s) created in $outputDir');
}

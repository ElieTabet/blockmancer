import 'package:blockmancer_app/application/application.dart';

void main(List<String> args) async {
  final Application app = Application();

  await app.boot(args);
  app.launch();
}

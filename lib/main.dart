
import 'package:flirtbees/my_app.dart';
import 'package:flirtbees/utils/app_config.dart';

Future<void> main() async {
  // Init dev config
  Config(environment: Env.dev());
  await myMain();
}

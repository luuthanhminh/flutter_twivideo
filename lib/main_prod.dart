
import 'package:flirtbees/my_app.dart';
import 'package:flirtbees/utils/app_config.dart';

Future<void> main() async {
  // Init prod config
  Config(environment: Env.prod());
  await myMain();
}

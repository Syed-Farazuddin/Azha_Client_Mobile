import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/app/app.dart';
import 'package:mobile/bootstrap.dart';

void main() {
  dotenv.load(fileName: '.env');

  bootstrap(() => const App());
}

import 'package:authentication/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:mikhuy/app/app.dart';
import 'package:mikhuy/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.userStream.first;

  await bootstrap(
    () => App(
      authenticationRepository: authenticationRepository,
    ),
  );
}

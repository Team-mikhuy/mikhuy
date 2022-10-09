import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/sign_in/sign_in.dart';
import 'package:mikhuy/sign_up/sign_up.dart';

part 'sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: SignInPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocProvider(
          create: (_) => SignInCubit(context.read<AuthenticationRepository>()),
          child: const SignInForm(),
        ),
      ),
    );
  }
}

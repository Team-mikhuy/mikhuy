import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/sign_up/sign_up.dart';
import 'package:mikhuy/theme/theme.dart';

part 'sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).textTheme.headline1,
        iconTheme: IconThemeData(color: AppColors.flushOrange.shade800),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Crea tu cuenta',
          style: TextStyle(
            color: AppColors.flushOrange.shade800,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocProvider<SignUpCubit>(
                    create: (_) =>
                        SignUpCubit(context.read<AuthenticationRepository>()),
                    child: const SignUpForm(),
                  ),
                  const Divider(height: 64),
                  Text(
                    '¿YA TIENES UNA CUENTA?',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 8),
                  _SignInButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('signUpForm_goToSignIn_flatButton'),
        onPressed: () => Navigator.of(context).pop(),
        style: AppTheme.secondaryButton,
        child: const Text('INICIAR SESIÓN'),
      ),
    );
  }
}

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:mikhuy/sign_in/sign_in.dart';
import 'package:mikhuy/sign_up/sign_up.dart';
import 'package:mikhuy/theme/theme.dart';

part 'sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: SignInPage());

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignInPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/logo-outline-mikhuy.svg',
                    height: 124,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    '¡Bienvenido a Mikhuy!',
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: AppColors.flushOrange.shade800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Inicia sesión para ingresar :)',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: AppColors.flushOrange.shade800),
                  ),
                  const SizedBox(height: 64),
                  BlocProvider(
                    create: (_) =>
                        SignInCubit(context.read<AuthenticationRepository>()),
                    child: const SignInForm(),
                  ),
                  const Divider(height: 64),
                  Text(
                    '¿AÚN NO TIENES UNA CUENTA?',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SizedBox(height: 8),
                  _SignUpButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('signInForm_createAccount_flatButton'),
        onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
        style: AppTheme.secondaryButton,
        child: const Text('CREAR CUENTA'),
      ),
    );
  }
}

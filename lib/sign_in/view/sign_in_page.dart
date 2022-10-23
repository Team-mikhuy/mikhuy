import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:mikhuy/sign_in/sign_in.dart';
import 'package:mikhuy/sign_up/sign_up.dart';
import 'package:mikhuy/theme/theme.dart';

part 'sign_in_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: SignInPage());

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
                    'Inicia sesion para ingresar :)',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

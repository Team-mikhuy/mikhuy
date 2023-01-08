part of 'sign_in_page.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Ha ocurrido un problema inesperado :(',
                ),
              ),
            );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _EmailInput(),
          const SizedBox(height: 24),
          _PasswordInput(),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                final signInCubit = context.read<SignInCubit>();
                final message = await showDialog<String>(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      title: const Text('Recuperar contraseña'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ingresa tu correo electrónico:         '),
                          const SizedBox(height: 8),
                          BlocProvider.value(
                            value: signInCubit,
                            child: _EmailInput(),
                          ),
                        ],
                      ),
                      actionsPadding: const EdgeInsets.only(
                        bottom: 24,
                        left: 24,
                        right: 24,
                      ),
                      contentPadding: const EdgeInsets.all(24),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: AppTheme.secondaryButton,
                          child: const Text('Cancelar'),
                        ),
                        BlocProvider.value(
                          value: signInCubit,
                          child: const _RestorePasswordButton(),
                        ),
                      ],
                    );
                  },
                );
                if (message != null) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              },
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
              ),
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),
          const SizedBox(height: 32),
          _LoginButton(),
        ],
      ),
    );
  }
}

class _RestorePasswordButton extends StatelessWidget {
  const _RestorePasswordButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      buildWhen: (previous, current) =>
          previous.email != current.email ||
          previous.restorePasswordRequestStatus !=
              current.restorePasswordRequestStatus,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.email.invalid ||
                  state.restorePasswordRequestStatus == RequestStatus.inProgress
              ? null
              : () {
                  context.read<SignInCubit>().restorePassword();
                },
          child: const Text('Enviar'),
        );
      },
      listener: (context, state) {
        if (state.restorePasswordRequestStatus == RequestStatus.completed) {
          Navigator.of(context).pop(
            'Se envió un mensaje a su correo para restablecer la contraseña.',
          );
        } else if (state.restorePasswordRequestStatus == RequestStatus.failed) {
          Navigator.of(context).pop(
            'Ocurrió un error inesperado, inténtelo de nuevo.',
          );
        }
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_emailInput_textField'),
          onChanged: (email) => context.read<SignInCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            errorText: state.email.invalid ? 'Correo inválido' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signInForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SignInCubit>().passwordChanged(password),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            errorText: state.password.invalid ? 'Contraseña vacía' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: const Key('signInForm_continue_raisedButton'),
                  onPressed: state.status.isValidated
                      ? () => context.read<SignInCubit>().logInWithCredentials()
                      : null,
                  child: const Text('INICIAR SESIÓN'),
                ),
              );
      },
    );
  }
}

part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.name = const Name.pure(),
    this.birthdate = const BirthDate.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final Name name;
  final BirthDate birthdate;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props =>
      [email, password, confirmedPassword, name, birthdate, status];

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    Name? name,
    BirthDate? birthdate,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      name: name ?? this.name,
      birthdate: birthdate ?? this.birthdate,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

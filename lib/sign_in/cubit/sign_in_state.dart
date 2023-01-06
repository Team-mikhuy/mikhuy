part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  const SignInState({
    this.restorePasswordRequestStatus = RequestStatus.initial,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final RequestStatus restorePasswordRequestStatus;
  final Email email;
  final Password password;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [
        restorePasswordRequestStatus,
        email,
        password,
        status,
      ];

  SignInState copyWith({
    RequestStatus? restorePasswordRequestStatus,
    Email? email,
    Password? password,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return SignInState(
      restorePasswordRequestStatus:
          restorePasswordRequestStatus ?? this.restorePasswordRequestStatus,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

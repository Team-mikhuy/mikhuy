import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:mikhuy/shared/shared.dart';
import 'package:mikhuy/sign_up/sign_up.dart';
import 'package:models/models.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          email,
          state.password,
          state.confirmedPassword,
          state.name,
          state.birthdate,
          state.genre,
          state.username,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.email,
          password,
          confirmedPassword,
          state.name,
          state.birthdate,
          state.genre,
          state.username,
        ]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        status: Formz.validate([
          state.email,
          state.password,
          confirmedPassword,
          state.name,
          state.birthdate,
          state.genre,
          state.username,
        ]),
      ),
    );
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);

    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([
          state.email,
          state.password,
          state.confirmedPassword,
          name,
          state.birthdate,
          state.genre,
          state.username,
        ]),
      ),
    );
  }

  void birthdateChanged(DateTime? value) {
    final birthdate = BirthDate.dirty(value);
    emit(
      state.copyWith(
        birthdate: birthdate,
        status: Formz.validate([
          state.email,
          state.password,
          state.confirmedPassword,
          state.name,
          birthdate,
          state.genre,
          state.username,
        ]),
      ),
    );
  }

  void genreChanged(String value) {
    final genre = Genre.dirty(value);

    emit(
      state.copyWith(
        genre: genre,
        status: Formz.validate([
          state.email,
          state.password,
          state.confirmedPassword,
          state.name,
          state.birthdate,
          genre,
          state.username,
        ]),
      ),
    );
  }

  void usernameChanged(String value) {
    final username = Username.dirty(value);

    emit(
      state.copyWith(
        username: username,
        status: Formz.validate([
          state.email,
          state.password,
          state.confirmedPassword,
          state.name,
          state.birthdate,
          state.genre,
          username,
        ]),
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final user = User.empty.copyWith(
        name: state.name.value,
        mail: state.email.value,
        username: state.username.value,
        genre: state.genre.value,
        birthdate: state.birthdate.value,
      );

      await _authenticationRepository.signUp(
        user: user,
        password: state.password.value,
      );

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}

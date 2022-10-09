import 'package:formz/formz.dart';

/// Validation errors for the [Username] [FormzInput].
enum UsernameValidationError {
  /// Username contains invalid characters error.
  invalid,

  /// Username is empty error.
  empty
}

/// {@template username}
/// Form input for an username input.
/// {@endtemplate}
class Username extends FormzInput<String, UsernameValidationError> {
  /// {@macro username}
  const Username.pure() : super.pure('');

  /// {@macro username}
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String? value) {
    if (value == null) return UsernameValidationError.empty;
    return RegExp(r'^(?=.{8,20}$)[a-zA-Z0-9._]+$').hasMatch(value)
        ? null
        : UsernameValidationError.invalid;
  }
}

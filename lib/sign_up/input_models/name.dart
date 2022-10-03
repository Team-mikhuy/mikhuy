import 'package:formz/formz.dart';

/// Validation errors for the [Name] [FormzInput].
enum NameValidationError {
  /// Name length is too short (less than 3 characters) error.
  tooShort,

  /// Name is empty error.
  empty
}

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class Name extends FormzInput<String, NameValidationError> {
  /// {@macro password}
  const Name.pure() : super.pure('');

  /// {@macro password}
  const Name.dirty([super.value = '']) : super.dirty();

  @override
  NameValidationError? validator(String? value) {
    if (value == null) return NameValidationError.empty;
    return value.length >= 3 ? null : NameValidationError.tooShort;
  }
}

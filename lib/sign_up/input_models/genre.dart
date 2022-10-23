import 'package:formz/formz.dart';

/// Validation errors for the [Genre] [FormzInput].
enum GenreValidationError {
  /// Genre is empty error.
  empty
}

/// {@template genre}
/// Form input for a genre input.
/// {@endtemplate}
class Genre extends FormzInput<String, GenreValidationError> {
  /// {@macro genre}
  const Genre.pure() : super.pure('');

  /// {@macro genre}
  const Genre.dirty([super.value = '']) : super.dirty();

  @override
  GenreValidationError? validator(String? value) {
    return value == null ? GenreValidationError.empty : null;
  }
}

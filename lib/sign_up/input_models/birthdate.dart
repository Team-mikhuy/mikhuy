import 'package:formz/formz.dart';

/// Validation errors for the [BirthDate] [FormzInput].
enum BirthDateValidationError {
  /// Date is before 1950 or after current date, so it is invalid error.
  invalid,

  /// Date is empty error.
  empty
}

/// {@template birthdate}
/// Form input for a birthdate input.
/// {@endtemplate}
class BirthDate extends FormzInput<DateTime?, BirthDateValidationError> {
  /// {@macro birthdate}
  const BirthDate.pure() : super.pure(null);

  /// {@macro birthdate}
  BirthDate.dirty(super.value) : super.dirty();

  @override
  BirthDateValidationError? validator(DateTime? value) {
    if (value == null) return BirthDateValidationError.empty;
    if (value == DateTime(0)) return BirthDateValidationError.empty;

    return value.year < 1950 || value.isAfter(DateTime.now())
        ? BirthDateValidationError.invalid
        : null;
  }
}

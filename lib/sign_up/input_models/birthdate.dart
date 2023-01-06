import 'package:formz/formz.dart';

/// Validation errors for the [BirthDate] [FormzInput].
enum BirthDateValidationError {
  /// Date is before current date - 16 years.
  /// User must be at least 16 years old.
  under16('Sólo mayores de 16'),

  /// Date is empty error.
  empty('Campo vacío');

  const BirthDateValidationError(this.errorMessage);
  final String errorMessage;
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

    final is16OrOlder = value.isBefore(
      DateTime(
        DateTime.now().subtract(const Duration(days: 365 * 16)).year,
      ),
    );

    if (!is16OrOlder) return BirthDateValidationError.under16;
    return null;
  }
}

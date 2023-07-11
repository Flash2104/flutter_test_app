import 'package:formz/formz.dart';

enum NameValidationError { empty, invalid }

class NameInput extends FormzInput<String, NameValidationError> {
  const NameInput.pure({required this.isRequired}) : super.pure('');
  const NameInput.dirty({
    required this.isRequired,
    required String value,
  }) : super.dirty(value);

  final bool isRequired;
  static final regExp = RegExp(r'^[a-zA-Z_]*$');

  @override
  NameValidationError? validator(String value) {
    if (isRequired && value.isEmpty) return NameValidationError.empty;
    if (value.isNotEmpty && !regExp.hasMatch(value)) return NameValidationError.invalid;
    return null;
  }
}

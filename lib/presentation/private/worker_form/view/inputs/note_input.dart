import 'package:formz/formz.dart';

enum NoteValidationError { invalid }

class NoteInput extends FormzInput<String, NoteValidationError> {
  const NoteInput.pure() : super.pure('');
  const NoteInput.dirty({
    required String value,
  }) : super.dirty(value);

  @override
  NoteValidationError? validator(String value) {
    return null;
  }
}

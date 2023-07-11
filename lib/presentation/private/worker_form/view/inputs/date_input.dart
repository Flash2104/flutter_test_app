import 'dart:developer';

import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

enum DateValidationError { empty, invalid }

class DateInput extends FormzInput<String, DateValidationError> {
  const DateInput.pure() : super.pure('');
  const DateInput.dirty({
    required String value,
  }) : super.dirty(value);
  static final DATE_FORMAT = DateFormat('dd.MM.yyyy');
  @override
  DateValidationError? validator(String value) {
    if (value.isEmpty) return DateValidationError.empty;
    try {
      final parsed = DATE_FORMAT.parse(value);
      log('$parsed');
      return null;
    } catch (e) {
      return DateValidationError.invalid;
    }
  }
}

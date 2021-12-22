class ValidatorHandler {
  factory ValidatorHandler() {
    return _mainValidatorHandler;
  }

  ValidatorHandler._internal();

  static final ValidatorHandler _mainValidatorHandler =
      ValidatorHandler._internal();

  String? validateBasic(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill first';
    } else {
      return null;
    }
  }
}

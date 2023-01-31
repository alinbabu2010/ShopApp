class FormValidator {
  static checkTitle(String? value) {
    if (value?.isEmpty == true) {
      return "Please provide a title.";
    }
    return null;
  }

  static String? checkDescription(String? value) {
    if (value?.isEmpty == true) {
      return "Please enter a description.";
    }
    if (value?.length.compareTo(10).isNegative == true) {
      return 'Should be at least 10 characters long.';
    }
    return null;
  }

  static String? checkPrice(String? value) {
    if (value?.isEmpty == true) {
      return "Please provide a price.";
    }
    if (double.tryParse(value!) == null) {
      return "Please provide a valid number.";
    }
    if (double.parse(value) <= 0) {
      return "Please enter a number greater than zero.";
    }
    return null;
  }

  static String? checkUrl(String? value, {bool checkEmpty = true}) {
    if (value?.isEmpty == true) {
      return checkEmpty ? "Please enter an image URL" : null;
    }
    if (value?.startsWith('http') == false ||
        value?.startsWith('https') == false) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? checkValidEmail(String? value) {
    if (value?.isEmpty == true || value?.contains('@') == false) {
      return 'Invalid email!';
    }
    return null;
  }

  static String? checkValidPassword(String? value) {
    if (value?.isEmpty == true ||
        value?.length.compareTo(5).isNegative == true) {
      return 'Password is too short!';
    }
    return null;
  }

  static String? checkPasswordMatch(
    String? password,
    String? reenteredPassword,
  ) {
    if (password != reenteredPassword) {
      return 'Passwords do not match!';
    }
    return null;
  }
}

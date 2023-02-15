// Class used to check for user inputs
class Validator {

  // Make sure there is input for a User's name
  static String? validateName({required String name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }
    return null;
  }

  // General function to require non-empty boxes
  static String? validateText({required String text}) {
    if (text == null) {
      return null;
    }
    if (text.isEmpty) {
      return 'Text can\'t be empty';
    }
    return null;
  }

  // Checks for a valid Email input
  static String? validateEmail({required String email}) {
    if (email == null) {
      return null;
    }

    // Reg expression pattern for email
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }
    return null;
  }

  // Checks for valid password input
  static String? validatePassword({required String password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }
    return null;
  }
}
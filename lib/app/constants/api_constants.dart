import 'credentials.dart';

class ApiConstants {
  static const parseUrl = "https://parseapi.back4app.com/";
  static const back4AppId = appID;
  static const back4AppAPIKey = apiKey;

  static const task = "classes/Task";
  static const users = "users";
  static const login = "login";
}

class EventConstants {
  static const int requestSuccessful = 10;
  static const int requestUnsuccessful = 11;
  static const int requestInvalid = 15;
  static const int preconditionFailed = 17;
}

class EventMessages {
  static const String preconditionFailed = 'Pre condition failed';
}

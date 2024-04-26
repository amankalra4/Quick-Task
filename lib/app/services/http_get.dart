import 'dart:async';
import 'package:http/http.dart' as http;

import '../exports.dart';

Map<String, String> constructHeaders({
  bool includeRevocableSession = true,
}) {
  Map<String, String> headers = {
    'X-Parse-Application-Id': ApiConstants.back4AppId,
    'X-Parse-REST-API-Key': ApiConstants.back4AppAPIKey,
    'Content-Type': 'application/json',
  };

  if (includeRevocableSession) {
    headers['X-Parse-Revocable-Session'] = '1';
  }

  return headers;
}

Future<EventObject> httpGet(
    {required http.Client client,
    required String url,
    bool isUserApi = false}) async {
  final http.Response response;
  try {
    response = await client.get(
      Uri.parse(ApiConstants.parseUrl + url),
      headers: constructHeaders(includeRevocableSession: isUserApi),
    );

    switch (response.statusCode) {
      case 200:
      case 201:
        return EventObject(
          id: EventConstants.requestSuccessful,
          response: response.body,
        );
      case 400:
      case 401:
        return EventObject(
          id: EventConstants.requestUnsuccessful,
          response: response.body,
        );
      default:
        return EventObject(
          id: EventConstants.requestUnsuccessful,
          response: 'Something went wrong',
        );
    }
  } catch (exception) {
    return EventObject(
      id: EventConstants.requestUnsuccessful,
      response: 'Something went wrong',
    );
  }
}

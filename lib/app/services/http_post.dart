import 'dart:async';
import 'package:http/http.dart' as http;

import '../exports.dart';

Future<EventObject?> httpPost(
    {required http.Client client,
    required String url,
    Object? data,
    bool isUserApi = false}) async {
  final http.Response response;
  try {
    response = await client.post(
      Uri.parse(ApiConstants.parseUrl + url),
      headers: constructHeaders(includeRevocableSession: isUserApi),
      body: data,
    );

    switch (response.statusCode) {
      case 200:
      case 201:
        return EventObject(
          id: EventConstants.requestSuccessful,
          response: response.body,
        );
      case 302:
        return EventObject(
          id: EventConstants.preconditionFailed,
          response: EventMessages.preconditionFailed,
        );
      case 400:
      case 401:
      case 422:
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

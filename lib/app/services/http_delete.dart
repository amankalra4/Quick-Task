import 'dart:async';
import 'package:http/http.dart' as http;

import '../exports.dart';

Future<EventObject> httpDelete({
  required http.Client client,
  required String? objectId,
}) async {
  final String url = '${ApiConstants.parseUrl}/${ApiConstants.task}/$objectId';
  final http.Response response;
  try {
    response = await client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'X-Parse-Application-Id': ApiConstants.back4AppId,
        'X-Parse-REST-API-Key': ApiConstants.back4AppAPIKey,
        'accept': 'application/json',
      },
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

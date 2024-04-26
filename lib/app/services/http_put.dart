import 'dart:async';
import 'package:http/http.dart' as http;

import '../exports.dart';

Future<EventObject?> httpPut({
  required http.Client client,
  required String url,
  Object? data,
  required String? objectId,
}) async {
  final http.Response response;
  final String url = '${ApiConstants.parseUrl}/${ApiConstants.task}/$objectId';
  try {
    response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'X-Parse-Application-Id': ApiConstants.back4AppId,
        'X-Parse-REST-API-Key': ApiConstants.back4AppAPIKey,
        'accept': 'application/json',
      },
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
        throw Exception('Oops! Invalid response');
    }
  } catch (exception) {
    throw Exception('Oops! Invalid response');
  }
}

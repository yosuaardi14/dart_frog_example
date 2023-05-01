import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_example/database/models/user.dart';
import 'package:dart_frog_example/source/user_data_source.dart';

final contentTypePng = ContentType('image', 'png');

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final dataSource = context.read<UserDataSource>();
  final users = await dataSource.fetchAll();
  return Response.json(body: users);
}

///post json
// Future<Response> _post(RequestContext context) async {
//   final dataSource = context.read<UserDataSource>();
//   final user = User.fromJson(
//     await context.request.json() as Map<String, dynamic>,
//   );

//   return Response.json(
//     statusCode: HttpStatus.created,
//     body: await dataSource.add(user),
//   );
// }

///post multipart form data
Future<Response> _post(RequestContext context) async {
  final formData = await context.request.formData();
  final photo = formData.files['photo'];
  final jsonData = jsonDecode(formData.fields['data']!);

  final dataSource = context.read<UserDataSource>();
  var user = User.fromJson(
    jsonData as Map<String, dynamic>,
  );
  if ((photo != null) &&
      (photo.contentType.mimeType == contentTypePng.mimeType)) {
    // final img = Uint8List.fromList(await photo.readAsBytes());
    final img = base64Encode(await photo.readAsBytes());
    user = user.copyWith(image: img);
  }

  return Response.json(
    statusCode: HttpStatus.created,
    body: await dataSource.add(user),
  );
}

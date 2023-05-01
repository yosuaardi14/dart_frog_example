import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'dart:typed_data';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_example/database/models/user.dart';
import 'package:dart_frog_example/source/user_data_source.dart';

final contentTypePng = ContentType('image', 'png');

FutureOr<Response> onRequest(RequestContext context, String id) async {
  final dataSource = context.read<UserDataSource>();
  final user = await dataSource.fetchById(id);

  if (user == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Not found');
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, user);
    case HttpMethod.post:
      return _put(context, id, user);
    case HttpMethod.delete:
      return _delete(context, id);
    case HttpMethod.put:
    // return _put(context, id, user);
    case HttpMethod.head:
    case HttpMethod.patch:
    case HttpMethod.options:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, User user) async {
  return Response.json(body: user);
}

///put json
// Future<Response> _put(RequestContext context, String id, User user) async {
//   final dataSource = context.read<UserDataSource>();
//   final updatedUser = User.fromJson(
//     await context.request.json() as Map<String, dynamic>,
//   );
//   final newUser = await dataSource.update(
//     id,
//     user.copyWith(
//       name: updatedUser.name,
//       age: updatedUser.age,
//     ),
//   );

//   return Response.json(body: newUser);
// }

///post multipart
Future<Response> _put(RequestContext context, String id, User user) async {
  final formData = await context.request.formData();
  final photo = formData.files['photo'];
  var updatedUser = User();
  if (formData.fields.containsKey('data')) {
    final jsonData =
        jsonDecode(formData.fields['data']!) as Map<String, dynamic>;
    updatedUser = User.fromJson(jsonData);
  }
  final dataSource = context.read<UserDataSource>();

  if ((photo != null) &&
      (photo.contentType.mimeType == contentTypePng.mimeType)) {
    // final img = Uint8List.fromList(await photo.readAsBytes());
    final img = base64Encode(await photo.readAsBytes());
    updatedUser = updatedUser.copyWith(image: img);
  }

  final newUser = await dataSource.update(
    id,
    user.copyWith(
      name: updatedUser.name,
      age: updatedUser.age,
      image: updatedUser.image,
    ),
  );

  return Response.json(body: newUser);
}

Future<Response> _delete(RequestContext context, String id) async {
  final dataSource = context.read<UserDataSource>();
  await dataSource.delete(id);
  return Response(statusCode: HttpStatus.noContent);
}

import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_example/database/models/book.dart';
import 'package:dart_frog_example/source/book_data_source.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  final dataSource = context.read<BookDataSource>();
  final book = await dataSource.fetchById(id);

  if (book == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Not found');
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, book);
    case HttpMethod.delete:
      return _delete(context, id);
    case HttpMethod.put:
      return _put(context, id, book);
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.patch:
    case HttpMethod.options:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, Book book) async {
  return Response.json(body: book);
}

Future<Response> _put(RequestContext context, String id, Book book) async {
  final dataSource = context.read<BookDataSource>();
  final updatedBook = Book.fromJson(
    await context.request.json() as Map<String, dynamic>,
  );
  final newBook = await dataSource.update(
    id,
    book.copy(updatedBook),
  );

  return Response.json(body: newBook);
}

Future<Response> _delete(RequestContext context, String id) async {
  final dataSource = context.read<BookDataSource>();
  await dataSource.delete(id);
  return Response(statusCode: HttpStatus.noContent);
}

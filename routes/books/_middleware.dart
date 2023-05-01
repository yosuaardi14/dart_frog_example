import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_cors/dart_frog_cors.dart';
import 'package:dart_frog_example/database/sql_client.dart';
import 'package:dart_frog_example/source/book_data_source.dart';

Handler middleware(Handler handler) {
  return handler.use(cors()).use(requestLogger()).use(injectionHandler());
}

Middleware injectionHandler() {
  return (handler) {
    return handler.use(
      provider<BookDataSource>(
        (context) => BookDataSource(context.read<MySQLClient>()),
      ),
    );
  };
}

class ServerException implements Exception {}

class CacheException implements Exception {}

class AppException implements Exception {
  final String message;
  final String prefix;

  AppException(this.prefix,this.message);

  @override
  String toString() {
    return "$prefix $message";
  }
}

class FetchDataException extends AppException {
  FetchDataException({required String message})
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException({required String message}) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException({required String message}) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException({required String message}) : super(message, "Invalid Input: ");
}
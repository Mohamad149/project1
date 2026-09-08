class AppException implements Exception{
AppException(this.message , {this.code});

 final String message;
 final String? code;

String  toString()=> message;

}

class NetworkException extends AppException{
 NetworkException(super.message ,{super.code});
}

class AuthenticationException extends AppException{
 AuthenticationException(super.message ,{super.code});
}

class DatabaseException extends AppException{
 DatabaseException(super.message , {super.code});
}

class ValidationException extends AppException{
 ValidationException(super.message , {super.code});
}
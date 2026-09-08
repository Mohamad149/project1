class Failure implements Exception{
  Failure(this.message , {this.code});


  final String message;
  final String? code;


  List<Object?>get props => [message ,code];

String toString() => message;
}
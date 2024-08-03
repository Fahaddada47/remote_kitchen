class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic data;
  final String? message;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.data,
    this.message,
  });

  factory NetworkResponse.fromJson(Map<String, dynamic> json) {
    return NetworkResponse(
      isSuccess: json['isSuccess'],
      statusCode: json['statusCode'],
      data: json['data'],
      message: json['message'],
    );
  }
}

import 'package:dio/dio.dart';

class Server {
  final dio = Dio();

  Map<String, String> header() {
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    return headers;
  }

  Map<String, String> headerWithToken() {
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    return headers;
  }

  postRequest({required String endpoint, Map<String, dynamic>? body}) async {
    try {
      var response = await dio.post(
        endpoint,
        options: Options(
          headers: header(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: body,
      );
      return response;
    } catch (e) {
      final errorMessage = '$e';
      return errorMessage;
    }
  }

  postRequestWithToken({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      var response = await dio.post(
        endpoint,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
        data: body,
      );
      return response;
    } catch (e) {
      final errorMessage = '$e';
      return errorMessage;
    }
  }

  getRequest({required String endPoint, Map<String, dynamic>? body}) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: body,
        options: Options(
          headers: header(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }

  getRequestWithToken({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await dio.get(
        endPoint,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }

  putRequest({required String endPoint, Map<String, dynamic>? body}) async {
    try {
      final response = await dio.put(
        endPoint,
        queryParameters: body,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }

  putRequestWithToken({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await dio.put(
        endPoint,
        queryParameters: body,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }

  deleteRequest({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.delete(
        endPoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headerWithToken(),
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      final errorMessage = 'Error: $e';
      return errorMessage;
    }
  }
}

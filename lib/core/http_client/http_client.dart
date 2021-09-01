import 'package:http/http.dart' as http;

abstract class HttpClient {
  Future<HttpResponse> get(String url);
  Future<HttpResponse> post(String url, {Map<String, dynamic> body});
}

class HttpResponse {
  final dynamic data;
  final int statusCode;

  HttpResponse({this.data, this.statusCode});
}

class HttpImplementation implements HttpClient {
  final client = http.Client();
  @override
  Future<HttpResponse> get(String url) async {
    final response = await client.get(Uri.parse(url));
    return HttpResponse(data: response.body, statusCode: response.statusCode);
  }

  @override
  Future<HttpResponse> post(String url, {Map<String, dynamic> body}) {
    // TODO: implement post
    throw UnimplementedError();
  }
}

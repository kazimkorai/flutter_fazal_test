import 'package:http/http.dart' as http;

class Request {
  final String url;
  final dynamic body;
  final dynamic headers;

  Request({this.url, this.body, this.headers});


  Future<http.Response> post() {

    return http.post(url, body: body, headers: headers).timeout(Duration(minutes: 2));
  }
  Future<http.Response> get() {

    print('***'+url);

    return http.get(url, headers: headers).timeout(Duration(minutes: 2));
  }
}

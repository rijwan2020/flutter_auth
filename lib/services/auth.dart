import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final url = dotenv.env['REQRES_URL'];

	login(data) async{
		var fullUrl = '$url/login';
		return await http.post(
			Uri.parse(fullUrl),
			body: jsonEncode(data),
			headers: _setHeaders()
		);
	}

	register(data) async{
		var fullUrl = '$url/register';
		return await http.post(
			Uri.parse(fullUrl),
			body: jsonEncode(data),
			headers: _setHeaders()
		);
	}

	_setHeaders() => {
		'Content-type': 'application/json',
		'Accept': 'application/json',
	};

}
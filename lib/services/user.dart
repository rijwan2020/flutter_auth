import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService{
	final url = dotenv.env['GOREST_URL'];
	final token = dotenv.env['GOREST_TOKEN'];

	listUser () async{
		final uri = Uri.parse('$url/users');
		return await http.get(
			uri,
			headers: _setHeaders()
		);
	}

	createUser (data) async{
		final uri = Uri.parse('$url/users');
		return await http.post(
			uri,
			body: jsonEncode(data),
			headers: _setHeaders()
		);
	}

	updateUser (id, data) async{
		final uri = Uri.parse('$url/users/$id');
		return await http.put(
			uri,
			body: jsonEncode(data),
			headers: _setHeaders()
		);
	}

	deleteUser (id) async{
		final uri = Uri.parse('$url/users/$id');
		return await http.delete(
			uri,
			headers: _setHeaders()
		);
	}

	_setHeaders() => {
		'Content-type': 'application/json',
		'Accept': 'application/json',
		'Authorization': 'Bearer $token',
	};
}
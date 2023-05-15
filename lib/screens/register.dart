// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_auth/services/auth.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home.dart';

class Register extends StatefulWidget{
  	const Register({Key? key}) : super(key: key);

	@override
	// ignore: library_private_types_in_public_api
	_RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{
	bool _isLoading = false;
	final _formKey = GlobalKey<FormState>();
	bool _secureText = true;
	String? name, email, password;

	showHide(){
		setState(() {
			_secureText = !_secureText;
		});
	}

	void showErrorMsg(String msg) {
		final snackBar = SnackBar(
			content: Text(
				msg,
				style: const TextStyle(
					color: Colors.white
				),
			),
			backgroundColor: Colors.red,
		);
		ScaffoldMessenger.of(context).showSnackBar(snackBar);
	}

	@override
	Widget build(BuildContext context){
		return Scaffold(
			backgroundColor: const Color(0xff151515),
			body: SafeArea(
				child: SingleChildScrollView(
					padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 72),
					child: Column(
						children: [
							Card(
								elevation: 4.0,
								color: Colors.white10,
								margin: const EdgeInsets.only(top: 86),
								shape: RoundedRectangleBorder(
									borderRadius: BorderRadius.circular(14),
								),
								child: Padding(
									padding: const EdgeInsets.all(24),
									child: Form(
										key: _formKey,
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												const Text(
													"Register",
													textAlign: TextAlign.center,
													style: TextStyle(
														fontSize: 24,
														fontWeight: FontWeight.bold,
													),
												),
												const SizedBox(height: 18),
												TextFormField(
													cursorColor: Colors.blue,
													keyboardType: TextInputType.text,
													decoration: const InputDecoration(
														hintText: "Full Name",
													),
													validator: (nameValue){
														if(nameValue!.isEmpty){
															return 'Please enter your full name';
														}
														name = nameValue;
														return null;
													}
												),
												const SizedBox(height: 12),
												TextFormField(
													cursorColor: Colors.blue,
													keyboardType: TextInputType.text,
													decoration: const InputDecoration(
														hintText: "Email",
													),
													validator: (emailValue){
														if(emailValue!.isEmpty){
															return 'Please enter your email';
														}
														email = emailValue;
														return null;
													}
												),
												const SizedBox(height: 12),
												TextFormField(
													cursorColor: Colors.blue,
													keyboardType: TextInputType.text,
													obscureText: _secureText,
													decoration: InputDecoration(
														hintText: "Password",
														suffixIcon: IconButton(
															onPressed: showHide,
															icon: Icon(_secureText
																? Icons.visibility_off
																: Icons.visibility
															),
														),
													),
													validator: (passwordValue){
														if(passwordValue!.isEmpty){
															return 'Please enter your password';
														}
														password = passwordValue;
														return null;
													}
												),
												const SizedBox(height: 12),
												FlatButton(
													color: Colors.blueAccent,
													disabledColor: Colors.grey,
													shape: RoundedRectangleBorder(
														borderRadius:
														BorderRadius.circular(20.0)
													),
													onPressed: () {
														if (_formKey.currentState!.validate()) {
															_register();
														}
													},
													child: Padding(
														padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
														child: Text(
															_isLoading? 'Proccessing..' : 'Register',
															textDirection: TextDirection.ltr,
															style: const TextStyle(
																color: Colors.white,
																fontSize: 18.0,
																decoration: TextDecoration.none,
																fontWeight: FontWeight.normal,
															),
														),
													),
												),
											],
										),
									),
								),
							),
							const SizedBox(height: 24),
							Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									const Text(
										"Already have an account? ",
										style: TextStyle(
											color: Colors.white,
											fontSize: 16,
										),
									),
									InkWell(
										onTap: () {
											Navigator.pop(
												context,
												MaterialPageRoute(
													builder: (context) => const Login()
												)
											);
										},
										child: const Text(
											'Login',
											style: TextStyle(
												color: Colors.white,
												fontSize: 16.0,
												decoration: TextDecoration.none,
												fontWeight: FontWeight.bold,
											),
										),
									),
								],
							)
						],
					),
				),
			),
		);
	}

	void _register() async{
		setState(() {
			_isLoading = true;
		});
		var data = {
			'name' : name,
			'email' : email,
			'password' : password
		};
		var res = await AuthService().register(data);
		var body = jsonDecode(res.body);
		final statusCode = res.statusCode;
		if (statusCode == 200) {
			SharedPreferences localStorage = await SharedPreferences.getInstance();
			localStorage.setString('token', json.encode(body['token']));
			localStorage.setString('user', json.encode(data));
			// ignore: use_build_context_synchronously
			Navigator.pushReplacement(
				context,
				MaterialPageRoute(
					builder: (context) => const Home()
				),
			);
		} else {
			final error = body['error'];
			showErrorMsg(error.toString());
		}
		setState(() {
			_isLoading = false;
		});
	}
}
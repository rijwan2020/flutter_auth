import 'package:flutter/material.dart';
import 'package:flutter_auth/services/auth.dart';
import 'register.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
	State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
	bool _isLoading = false;
	final _formKey = GlobalKey<FormState>();
	String? email, password;
	bool _secureText = true;

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
													"Login",
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
																	: Icons.visibility),
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
												ElevatedButton(
													onPressed: () {
														if (_formKey.currentState!.validate()) {
															_login();
														}
													},
													child: Padding(
														padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
														child: Text(
															_isLoading? 'Proccessing..' : 'Login',
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
										"Does'nt have an account? ",
										style: TextStyle(
											color: Colors.white,
											fontSize: 16,
										),
									),
									InkWell(
										onTap: () {
											Navigator.push(
												context,
												MaterialPageRoute(
													builder: (context) => const Register()
												)
											);
										},
										child: const Text(
											'Register',
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

	void _login() async{
		setState(() {
			_isLoading = true;
		});
		var data = {
			'email' : email,
			'password' : password
		};

		var res = await AuthService().login(data);
		var body = json.decode(res.body);
		final statusCode = res.statusCode;
		if (statusCode == 200) {
			SharedPreferences localStorage = await SharedPreferences.getInstance();
			localStorage.setString('token', json.encode(body['token']));
      navigationToHome();
		} else {
			final error = body['error'];
			showErrorMsg(error.toString());
		}

		setState(() {
			_isLoading = false;
		});
	}

	Future<void> navigationToHome() async{
		final route = MaterialPageRoute(
			builder: (context) => const Home(),
		);
		await Navigator.push(context, route);
	}
}
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
	await dotenv.load(fileName: '.env');
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Test',
			debugShowCheckedModeBanner: false,
			home: const CheckAuth(),
			darkTheme: ThemeData(brightness: Brightness.dark),
			themeMode: ThemeMode.dark,
		);
	}
}
class CheckAuth extends StatefulWidget{
	const CheckAuth({Key? key}) : super(key: key);

	@override
	// ignore: library_private_types_in_public_api
	_CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth>{
	bool isAuth = false;

	@override
	void initState(){
		super.initState();
		_checkIfLoggedIn();
	}

	void _checkIfLoggedIn() async {
		SharedPreferences localStorage = await SharedPreferences.getInstance();
		var token = localStorage.getString('token');
		if(token != null){
			if(mounted){
				setState(() {
					isAuth = true;
				});
			}
		}
	}

	@override
	Widget build(BuildContext context){
		Widget child;
		if(isAuth){
			child = const Home();
		} else{
			child = const Login();
		}

		return Scaffold(
			body: child,
		);
	}
}
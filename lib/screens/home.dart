import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/user_form.dart';
import 'package:flutter_auth/services/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'login.dart';

class Home extends StatefulWidget{
	const Home({Key? key}) : super(key: key);

	@override
	// ignore: library_private_types_in_public_api
	_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
	List users = [];
	bool _isLoading = true;

	@override
	void initState(){
		super.initState();
		getListUser();
	}

	@override
	Widget build(BuildContext context){
		return Scaffold(
			backgroundColor: const Color(0xff151515),
			appBar: AppBar(
				title: const Text('User List'),
				backgroundColor: const Color(0xff151515),
				automaticallyImplyLeading: false,
				actions: [
				IconButton(
					icon: const Icon(Icons.power_settings_new),
					onPressed: (){
						logout();
					},
				)
				],
			),
			floatingActionButton: FloatingActionButton.extended(
				onPressed: navigationToAdd,
				label: const Text('Add User')
			),
			body: Visibility(
				visible: _isLoading,
				replacement: RefreshIndicator(
					onRefresh: getListUser,
					child: ListView.builder(
						itemCount: users.length,
						itemBuilder: (context, index) {
							final user = users[index] as Map;
							final nomor = index + 1;
							final id = user['id'];
							return ListTile(
								leading: CircleAvatar(
									child: Text(nomor.toString()),
								),
								title: Text(user['name']),
								subtitle: Text(user['email']),
								trailing: PopupMenuButton(
									onSelected: (value) {
									  if (value == 'edit') {
										navigationToEdit(user);
									  } else if (value == 'delete') {
										deleteUser(id);
									  }
									},
									itemBuilder: (context) {
										return [
											const PopupMenuItem(
												value: 'edit',
												child: Text('Edit'),
											),
											const PopupMenuItem(
												value: 'delete',
												child: Text('Delete'),
											),
										];
									}
								),
							);
						}
					),
				),
				child: const Center(
					child: CircularProgressIndicator(),
				),
			),
		);
	}

	Future<void> navigationToAdd() async{
		final route = MaterialPageRoute(
			builder: (context) => const UserFormPage(),
		);
		await Navigator.push(context, route);
		getListUser();
	}

	Future<void> navigationToEdit(Map item) async{
		final route = MaterialPageRoute(
			builder: (context) => UserFormPage(user: item),
		);
		await Navigator.push(context, route);
		getListUser();
	}

  void logout() async{
		SharedPreferences localStorage = await SharedPreferences.getInstance();
		localStorage.remove('user');
		localStorage.remove('token');
		// ignore: use_build_context_synchronously
		Navigator.pushReplacement(
			context,
			MaterialPageRoute(builder: (context)=> const Login())
		);
	}

	Future<void> getListUser () async {
		setState(() {
		  _isLoading = true;
		});
		try {
			final response = await UserService().listUser();
			final statusCode = response.statusCode;
			if (statusCode != 200) {
			  throw "Get list user failed";
			}

			final json = jsonDecode(response.body);
			final list = json as List;
			setState(() {
			  users = list;
			});
		} catch (e) {
			showErrorMsg(e.toString());
		}
		setState(() {
		  _isLoading = false;
		});
	}

	Future<void> deleteUser(int id) async {
		try {
			final response = await UserService().deleteUser(id);
			final statusCode = response.statusCode;
			if (statusCode != 204) {
			  throw "Delete list user failed";
			}
			showSuccessMsg("User successfully deleted");
			// final filteredUser = users.where((element) => element['id'] != id).toList();
			// setState(() {
			//   users = filteredUser;
			// });
			getListUser();
		} catch (e) {
			showErrorMsg(e.toString());
		}
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

	void showSuccessMsg(msg) {
		final snackBar = SnackBar(
			content: Text(msg),
			backgroundColor: Colors.green,
		);
		ScaffoldMessenger.of(context).showSnackBar(snackBar);
	}
}
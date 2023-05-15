import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/home.dart';
import 'package:flutter_auth/services/user.dart';

class UserFormPage extends StatefulWidget {
  final Map? user;
	// const UserFormPage({Key? key}) : super(key: key);
  const UserFormPage({
    super.key,
    this.user,
  });

	@override
	State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
	TextEditingController nameController = TextEditingController();
	TextEditingController emailController = TextEditingController();
	String gender = 'male';
	String status = 'active';
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    if (user != null) {
      isEdit = true;
      final name = user['name'];
      final email = user['email'];
      nameController.text = name;
      emailController.text = email;
      gender = user['gender'];
      status = user['status'];
    }
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(
          isEdit ? 'Edit User' : 'Add User'
        ),
			),
			body: ListView(
				padding: const EdgeInsets.all(20),
				children: [
					TextField(
						controller: nameController,
						decoration: const InputDecoration(hintText: 'Name'),
					),

					const SizedBox(height: 20),
					TextField(
						controller: emailController,
						decoration: const InputDecoration(hintText: 'Email'),
					),

					const SizedBox(height: 20),
					const Text('Gender:'),
					RadioListTile(
						title: const Text("Male"),
						value: "male",
						groupValue: gender,
						onChanged: (value){
							setState(() {
								gender = value.toString();
							});
						},
					),
					RadioListTile(
						title: const Text("Female"),
						value: "female",
						groupValue: gender,
						onChanged: (value){
							setState(() {
								gender = value.toString();
							});
						},
					),

					const SizedBox(height: 20),
					const Text('Status:'),
					RadioListTile(
						title: const Text("Active"),
						value: "active",
						groupValue: status,
						onChanged: (value){
							setState(() {
								status = value.toString();
							});
						},
					),
					RadioListTile(
						title: const Text("Inactive"),
						value: "inactive",
						groupValue: status,
						onChanged: (value){
							setState(() {
								status = value.toString();
							});
						},
					),

					const SizedBox(height: 20),
					ElevatedButton(
						onPressed: isEdit ? updateData : submitData,
						child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                isEdit ? 'Update' : 'Submit'
              ),
            )
					)
				],
			),
		);
	}

  getParams() {
    final name = nameController.text;
		final email = emailController.text;
		final params = {
			'name': name,
			'email': email,
			'gender': gender,
			'status': status,
		};
    return params;
  }

  Future<void> updateData() async {
    try {
      final user = widget.user;
      if (user == null) {
        throw "User not found";
      }
      final id = user['id'];
      final params = getParams();
			if (params['name']!.isEmpty) {
				throw "Name is empty";
			}
			if (params['email']!.isEmpty) {
				throw "Email is empty";
			}
      final response = await UserService().updateUser(id, params);
			final statusCode = response.statusCode;
      if (statusCode != 200) {
        throw "Update user failed";
      }
      showSuccessMsg("User updated successfully");
			backToHome();
    } catch (e) {
      showErrorMsg(e.toString());
    }
  }

	Future<void> submitData () async {
		try {
		  final params = getParams();
			if (params['name']!.isEmpty) {
				throw "Name is empty";
			}
			if (params['email']!.isEmpty) {
				throw "Email is empty";
			}
			final response = await UserService().createUser(params);
			final statusCode = response.statusCode;
			if (statusCode == 422) {
			  throw "Create user failed";
			}
			showSuccessMsg("User created successfully");
			backToHome();
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

	void backToHome(){
		final route = MaterialPageRoute(
			builder: (context) => const Home(),
		);
		Navigator.push(context, route);
	}
}
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _users;

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  void _refreshUsers() {
    setState(() {
      _users = _apiService.getUsers();
    });
  }

  void _showUserForm({Map<String, dynamic>? user, required bool isEdit}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    if (isEdit && user != null) {
      _nameController.text = user['name'];
      _emailController.text = user['email'];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isEdit ? "Edit User" : "Add User",
          style: TextStyle(color: Color(0xFF001F54)),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an email";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                if (!isEdit)
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a password";
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(isEdit ? "Update" : "Add"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF001F54),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final name = _nameController.text;
                final email = _emailController.text;
                final password = _passwordController.text;

                try {
                  if (isEdit) {
                    final updatedPassword = password.isEmpty ? user!['password'] : password;
                    await _apiService.updateUser(user!['user_id'], name, email, updatedPassword);
                  } else {
                    await _apiService.createUser(name, email, password);
                  }
                  Navigator.pop(context, true); // Return true to refresh Dashboard
                  _refreshUsers();
                } catch (e) {
                  Navigator.pop(context);
                  _showErrorDialog(context, e.toString());
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Are you sure you want to delete this user?"),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                child: Text("Delete"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Users"),
        backgroundColor: Color(0xFF001F54),
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<dynamic>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No users found."));
          }

          final users = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF001F54).withOpacity(0.2),
                      child: Icon(Icons.person, color: Color(0xFF001F54)),
                    ),
                    title: Text(
                      user['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () => _showUserForm(user: user, isEdit: true),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await _showDeleteConfirmation(context);
                            if (confirm) {
                              await _apiService.deleteUser(user['user_id']);
                              Navigator.pop(context, true); // Return true to refresh Dashboard
                              _refreshUsers();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserForm(user: null, isEdit: false),
        backgroundColor: Color(0xFF001F54),
        child: Icon(Icons.add),
      ),
    );
  }
}

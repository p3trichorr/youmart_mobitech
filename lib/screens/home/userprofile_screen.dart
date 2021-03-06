import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';
import '../../model/user_model.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // string for displaying the error Message
  String? errorMessage;

  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController secondNameEditingController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //Profile name field
    final profileName = LayoutBuilder(builder: (context, constraints) {
      if (loggedInUser.role == 'Admin') {
        return const Text(
          "Your Admin Profile",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: colorPrimaryDark),
        );
      } else {
        return const Text(
          "Your Profile",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: colorPrimaryDark),
        );
      }
    });

    // first name field
    TextFormField firstNameField = TextFormField(
      controller: firstNameEditingController,
      autofocus: false,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Field cannot be empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: loggedInUser.firstName,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimary),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimary),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );

    // second name field
    TextFormField secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Field cannot be empty");
        }
        return null;
      },
      onSaved: (value) {
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: loggedInUser.secondName,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimary),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimary),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );

    //Update button
    final updateButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: colorPrimary,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          updateProfile(
              firstNameEditingController, secondNameEditingController);
          Navigator.of(context).pop();
        },
        child: const Text(
          "Update Account",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: colorWhite, fontWeight: FontWeight.bold),
        ),
      ),
    );

    //sign out button
    final signOutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: colorWhite,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signOut();
        },
        child: const Text(
          "Sign Out",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: colorAccent, fontWeight: FontWeight.bold),
        ),
      ),
    );

    //delete button
    final deleteButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: colorAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => showDialog<String>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Delete Account',
              style: TextStyle(
                fontSize: 25,
                color: colorAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: const Text(
              'Are you sure you want to delete account?',
              style: TextStyle(
                color: colorPrimaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: colorPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  deleteAccount();
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: colorAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            backgroundColor: colorWhite,
          ),
        ),
        child: const Text(
          "Delete Account",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: colorWhite, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: colorWhite,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: colorAccent),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
                color: colorWhite,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            height: 100,
                            child: Image.asset(
                              "images/Logo/Profile.png",
                              fit: BoxFit.contain,
                            )),
                        profileName,
                        const SizedBox(height: 3),
                        Text(
                          '${loggedInUser.email}',
                          style: const TextStyle(
                              fontSize: 18, color: colorPrimary),
                        ),
                        const SizedBox(height: 20),
                        firstNameField,
                        const SizedBox(height: 20),
                        secondNameField,
                        const SizedBox(height: 15),
                        updateButton,
                        const SizedBox(height: 15),
                        signOutButton,
                        const SizedBox(height: 15),
                        deleteButton,
                        const SizedBox(height: 45),
                      ],
                    ),
                  ),
                )),
          ),
        ));
  }

  updateProfile(firstNameEditingController, secondNameEditingController) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;

    if (firstNameEditingController.text == "" ||
        firstNameEditingController.text == " ") {
      firebaseFirestore.collection("users").doc(user.uid).update({
        'firstName': loggedInUser.firstName,
      });
    } else {
      firebaseFirestore.collection("users").doc(user.uid).update({
        'firstName': firstNameEditingController.text,
      });
    }

    if (secondNameEditingController.text == "" ||
        secondNameEditingController.text == " ") {
      firebaseFirestore.collection("users").doc(user.uid).update({
        'secondName': loggedInUser.secondName,
      });
    } else {
      firebaseFirestore.collection("users").doc(user.uid).update({
        'secondName': secondNameEditingController.text,
      });
    }
    Fluttertoast.showToast(msg: "Profile Updated");
  }

  deleteAccount() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;

    firebaseFirestore.collection("users").doc(user.uid).delete();
    user.delete();
    Fluttertoast.showToast(msg: "Account Deleted");

    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: "Signed Out");
    Navigator.of(context).pop();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:youmart_mobitech/widget/button_widget.dart';
import 'package:youmart_mobitech/api/firebase_api.dart';
import 'package:path/path.dart';


class AddItem extends StatefulWidget {
  AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  File? file;
  UploadTask? task;
  @override

  Widget build(BuildContext context) {
    //Controllers
    final itemNameController = TextEditingController();
    final itemPriceController = TextEditingController();
    final itemCategoryController = TextEditingController();
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    // item name field
    final itemNameField = TextFormField(
      autofocus: false,
      controller: itemNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{5,}$');
        if (value!.isEmpty) {
          return ("Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Valid Input(Min. 5 Char)");
        }
        return null;
      },
      onSaved: (value) {
        itemNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Item Name",
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimaryDark),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimaryDark),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );

    // item price field
    final itemPriceField = TextFormField(
      autofocus: false,
      controller: itemPriceController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Price cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        itemPriceController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Item Price",
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimaryDark),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimaryDark),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );

    // item category field
    final itemCategoryField = TextFormField(
      autofocus: false,
      controller: itemPriceController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{5,}$');
        if (value!.isEmpty) {
          return ("Category cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Valid Input(Min. 5 Char)");
        }
        return null;
      },
      onSaved: (value) {
        itemCategoryController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 8, 15),
        hintText: "Item Category",
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimaryDark),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: colorPrimaryDark),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );

    //Upload image button

    final uploadImageButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: colorPrimaryDark,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: selectFile,
        child: const Text(
          "Upload Image",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: colorSecondary, fontWeight: FontWeight.bold),
        ),
      ),
    );

    //Upload item button
    final uploadItemButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: colorPrimaryDark,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: uploadFile,
        child: const Text(
          "Upload Item",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: colorSecondary, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Input Item Details',
            style: TextStyle(
              fontSize: 25,
              color: colorPrimaryDark,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 25),
          itemNameField,
          const SizedBox(height: 25),
          itemPriceField,
          const SizedBox(height: 25),
          itemCategoryField,
          const SizedBox(height: 25),
          uploadImageButton,
          Text(
            fileName,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 20),
          uploadItemButton,
          task != null ? buildUploadStatus(task!) : Container(),
        ],
      ),
    );
  }
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'itemimage/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );

}

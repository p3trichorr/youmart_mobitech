import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../constants.dart';
import '../../../../model/product_upload.dart';

class DetailsUpdate extends StatefulWidget {
  final String pid, price, image, name, stock;

  const DetailsUpdate(
      {Key? key,
      required this.pid,
      required this.image,
      required this.name,
      required this.price,
      required this.stock})
      : super(key: key);

  @override
  State<DetailsUpdate> createState() => _DetailsUpdateState();
}

class _DetailsUpdateState extends State<DetailsUpdate> {
  //Controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  ProductUploadModel productUploadModel = ProductUploadModel();

  @override
  Widget build(BuildContext context) {
    // name field
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
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
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Item Name: ${widget.name}",
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

    // price field
    final priceField = TextFormField(
      autofocus: false,
      controller: priceController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Price cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        priceController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Item Price: ${widget.price}",
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

    //stock field
    final stockField = TextFormField(
      autofocus: false,
      controller: stockController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Stock cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        stockController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Item Stock: ${widget.stock}",
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

    //update button
    final updateButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: colorPrimaryDark,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: updateProduct,
        child: const Text(
          "Update Item",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: colorBase, fontWeight: FontWeight.bold),
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
              'Delete Item',
              style: TextStyle(
                fontSize: 25,
                color: colorAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'Are you sure you want to delete ${widget.name} from database?',
              style: const TextStyle(
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
                  Navigator.pop(context, 'Delete');
                  deleteProduct();
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
            backgroundColor: colorBase,
          ),
        ),
        child: const Text(
          "Delete Item",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18, color: colorBase, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: colorAccent),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: const Color(0xFFFFFFFF),
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: 200,
                          child: Image.network(
                            widget.image,
                            fit: BoxFit.contain,
                          )),
                      const SizedBox(height: 10),
                      nameField,
                      const SizedBox(height: 20),
                      priceField,
                      const SizedBox(height: 15),
                      stockField,
                      const SizedBox(height: 20),
                      updateButton,
                      const SizedBox(height: 10),
                      deleteButton,
                      const SizedBox(height: 45),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateProduct() {
    // writing all the values
    productUploadModel.pid = widget.pid;

    FirebaseFirestore.instance.collection("product").doc(widget.pid).update({
      'name': nameController.text,
      'price': priceController.text,
      'stock': stockController.text,
    });

    Fluttertoast.showToast(msg: "Product Updated");
    Navigator.of(context).pop();
  }

  deleteProduct() {
    FirebaseFirestore.instance.collection("product").doc(widget.pid).delete();

    Fluttertoast.showToast(msg: "Product Deleted");
    Navigator.of(context).pop();
  }
}

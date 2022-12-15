// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nomad/utils.dart';

class EditItemDialog extends StatefulWidget {
  final docId, docItemId, name;
  const EditItemDialog({Key? key, required this.docId,required this.name, required this.docItemId}) : super(key: key);

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {

  TextEditingController itemName = TextEditingController();

  updateData () {
    setState(() {
      itemName.text = widget.name;
    });
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        height: 300,
        width: 350,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 66, 65, 99),
              Color.fromARGB(255, 52, 63, 85),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Edit Item",
              style: TextStyle(
                fontSize: 30,
                letterSpacing: 5,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    prefixIcon: Icon(Icons.email, size: 30),
                    labelText: 'Item name',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300)),
                controller: itemName,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    if (itemName.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Item name can\t be empty',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ));
                      return;
                    }

                    FirebaseFirestore.instance.collection('Lists')
                        .doc(widget.docId).collection('Items')
                        .doc(widget.docItemId).update({'itemName': itemName.text.trim()});

                    Navigator.pop(context);

                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: veryLight,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
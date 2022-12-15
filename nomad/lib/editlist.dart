// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nomad/utils.dart';

class EditListDialog extends StatefulWidget {
  final name, docId;
  const EditListDialog({Key? key, required this.name, required this.docId}) : super(key: key);

  @override
  State<EditListDialog> createState() => _EditListDialogState();
}

class _EditListDialogState extends State<EditListDialog> {

  TextEditingController listName = TextEditingController();

  updateData () {
    setState(() {
      listName.text = widget.name;
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
              "Edit List Name",
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
                    labelText: 'List name',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300)),
                controller: listName,
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
                    if (listName.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('List name can\t be empty',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ));
                      return;
                    }

                    await FirebaseFirestore.instance.collection('Lists')
                        .doc(widget.docId).update({'listName': listName.text.trim()});

                    Navigator.pop(context);
                    Navigator.pop(context);
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
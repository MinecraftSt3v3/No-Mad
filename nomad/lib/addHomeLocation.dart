// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nomad/utils.dart';

class AddHomeLocation extends StatefulWidget {
  final docId;
  const AddHomeLocation({super.key, this.docId});

  @override
  State<AddHomeLocation> createState() => _AddCollaboratorState();
}

class _AddCollaboratorState extends State<AddHomeLocation> {
  TextEditingController collabratorEmail = TextEditingController();
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
              "Set current Location (Home)",
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: TextField(
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(borderSide: BorderSide()),
            //         labelText: '*******',
            //         labelStyle: TextStyle(
            //             color: Colors.white,
            //             fontSize: 18,
            //             fontWeight: FontWeight.w300)),
            //     controller: collabratorEmail,
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    if (collabratorEmail.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Item name can\t be empty',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ));
                      return;
                    }
                    QuerySnapshot doc = await FirebaseFirestore.instance
                        .collection('Users')
                        .where('email', isEqualTo: collabratorEmail.text)
                        .get();

                    FirebaseFirestore.instance
                        .collection('Lists')
                        .doc(widget.docId)
                        .update({
                      'collaborators':
                          FieldValue.arrayUnion([doc.docs.first.id.toString()])
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Set Location",
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

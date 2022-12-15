// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nomad/listItems.dart';
import 'package:nomad/utils.dart';

class AddList extends StatefulWidget {
  const AddList({Key? key}) : super(key: key);

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 250),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      prefixIcon: Icon(Icons.email, size: 30),
                      labelText: 'List name',
                      labelStyle: TextStyle(
                          color: veryLight,
                          fontSize: 18,
                          fontWeight: FontWeight.w300)),
                  controller: name,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (name.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('List name can\t be empty',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ));
                      return;
                    }

                    final doc = await FirebaseFirestore.instance.collection("Lists")
                        .doc();

                        doc.set({
                          "collaborators": [FirebaseAuth.instance.currentUser!.uid],
                          "listCreatedAt": DateTime.now(),
                          "listName": name.text.trim(),
                          "docId": doc.id
                    }, SetOptions(merge: true));

                    // ignore: use_build_context_synchronously
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ListItems(listName: name.text, docId: doc.id)));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: dark),
                  child: Text('Continue',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
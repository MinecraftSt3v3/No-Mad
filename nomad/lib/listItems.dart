// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nomad/addCollaborator.dart';
import 'package:nomad/addHomeLocation.dart';
import 'package:nomad/addItem.dart';
import 'package:nomad/edititem.dart';
import 'package:nomad/editlist.dart';
import 'package:nomad/home.dart';
import 'package:nomad/utils.dart';

class ListItems extends StatefulWidget {
  final listName, docId;
  const ListItems({Key? key, required this.listName, required this.docId})
      : super(key: key);

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: ((context) => AddItemDialog(docId: widget.docId)));
          },
          backgroundColor: darkOg,
          elevation: 10,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 26,
          ),
        ),
        appBar: AppBar(
          title: Text(widget.listName, style: TextStyle(color: veryLight)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (contex) => Home()),
                  (route) => false);
            },
          ),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: veryLight),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(child: Text('Add contributer'), value: 0),
                  PopupMenuItem(child: Text('Location Services'), value: 1),
                  PopupMenuItem(child: Text('Rename'), value: 2),
                  PopupMenuItem(child: Text('Delete List'), value: 3)
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  showDialog(
                      context: context,
                      builder: ((context) =>
                          AddCollaborator(docId: widget.docId)));
                } else if(value == 1) {
                  showDialog(
                    context: context,
                    builder:((context) =>
                    AddHomeLocation(docId: widget.docId)));
                } else if (value == 2) {
                  showDialog(
                      context: context,
                      builder: ((context) => EditListDialog(
                          name: widget.listName, docId: widget.docId)));
                } else if (value == 3) {
                  await FirebaseFirestore.instance
                      .collection('Lists')
                      .doc(widget.docId)
                      .delete();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Lists')
                    .doc(widget.docId)
                    .collection('Items')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 40),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Card(
                            color: dark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 20),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: snapshot.data!.docs[index]['check'],
                                    onChanged: ((value) async {
                                      setState(() {
                                        value = value!;
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('Lists')
                                          .doc(widget.docId)
                                          .collection('Items')
                                          .doc(snapshot.data!.docs[index]
                                              ['docItemId'])
                                          .update({'check': value});
                                    }),
                                    activeColor: darkOg,
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['itemName'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: ((context) => EditItemDialog(
                                                docId: widget.docId,
                                                name: snapshot.data!.docs[index]
                                                    ['itemName'],
                                                docItemId: snapshot.data!
                                                    .docs[index]['docItemId'],
                                              )));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          ),
        ));
  }
}

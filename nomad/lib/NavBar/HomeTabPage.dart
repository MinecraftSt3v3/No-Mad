
// ignore_for_file: prefer_const_constructors, division_optimization, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nomad/listItems.dart';
import 'package:nomad/utils.dart';
class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  int countTrue = 0;
  int countFalse = 0;

  getStats() async {
    List listId = [];

    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Lists")
        .where('collaborators',
            arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();

    qs.docs.forEach((element) {
      listId.add(element.id);
    });

    listId.forEach((element) async {
      QuerySnapshot ds = await FirebaseFirestore.instance
          .collection("Lists")
          .doc(element)
          .collection('Items')
          .get();
      ds.docs.forEach((element) {
        if (element.get('check') == true) {
          countTrue += 1;
        } else if (element.get('check') == false) {
          countFalse += 1;
        }

        setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  'Welcome back',
                  style: TextStyle(
                    color: veryLight,
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                  ),
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    color: light.withOpacity(0.5),
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Lists")
                              .where('collaborators',
                                  arrayContains:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return snapshot.data!.docs.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      'No List to Display',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    itemCount: snapshot.data!.docs.length,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ListItems(
                                                            listName:
                                                                snapshot.data!
                                                                            .docs[
                                                                        index][
                                                                    'listName'],
                                                            docId: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                ['docId'])));
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Card(
                                              color: dark,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 30,
                                                    horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          ['listName'],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          veryLight,
                                                      radius: 15,
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: dark,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                    });
                          },
                        ))),
              )),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.48,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Card(
                      color: Color.fromARGB(255, 232, 127, 71),
                      elevation: 10,
                      shadowColor: Colors.grey.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Completed Task',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 19,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(children: [
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: Offset(-5, 10),
                                      child: Text(
                                          countTrue==0 ? '0':
                                          ((countTrue * 100) /
                                                      (countTrue + countFalse))
                                                  .toInt()
                                                  .toString() +
                                              "%",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 50,
                                          ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.48,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Card(
                      color: Color.fromARGB(255, 151, 67, 215),
                      elevation: 10,
                      shadowColor: Colors.grey.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Uncompleted Task',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 19,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(children: [
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: Offset(-5, 10),
                                      child: Text(
                                        countTrue==0 ? '0' :
                                        ((countFalse * 100) /
                                                    (countTrue + countFalse))
                                                .toInt()
                                                .toString() +
                                            "%",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 50,
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
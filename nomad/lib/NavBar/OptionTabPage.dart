import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomad/login.dart';
import 'package:nomad/utils.dart';

class OptionTabpage extends StatefulWidget {
  const OptionTabpage({super.key});

  @override
  State<OptionTabpage> createState() => _OptionTabpageState();
}

class _OptionTabpageState extends State<OptionTabpage> {
  var profilePic;
  bool loading = false;
  String? url1;
  cropImage(var image) async {
    if (image != null) {
      File? croppedPhoto = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressQuality: 100,
          compressFormat: ImageCompressFormat.jpg,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Crop photo",
            toolbarColor: background,
            toolbarWidgetColor: light,
            activeControlsWidgetColor: dark,
          ));
      setState(() {
        profilePic = croppedPhoto;
        updateData();
      });
    }
  }

  updateData() {
    if (profilePic != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('Users/${FirebaseAuth.instance.currentUser!.uid}/profilePhoto')
          .child(FirebaseAuth.instance.currentUser!.uid +
              '-${DateTime.now().toString()}');
      UploadTask task = ref.putFile(profilePic);
      task.whenComplete(() async {
        url1 = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'profilephoto': url1});
      }).catchError((e) {
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: veryLight,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Column(
                  children: [
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.drag_handle_rounded,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 22,
                                                backgroundColor:
                                                    Colors.grey.shade300,
                                                child: Icon(
                                                  Icons.photo,
                                                  size: 26,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Text("Choose from gallery",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          onTap: () async {
                                            var tempImage = await ImagePicker()
                                                .pickImage(
                                                    source: ImageSource.gallery,
                                                    imageQuality: 95);
                                            cropImage(tempImage);
                                          },
                                        ),
                                        SizedBox(height: 10),
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 22,
                                                backgroundColor:
                                                    Colors.grey.shade300,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  size: 26,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Text("Take photo",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                          onTap: () async {
                                            var tempImage = await ImagePicker()
                                                .pickImage(
                                                    source: ImageSource.camera,
                                                    imageQuality: 95);
                                            cropImage(tempImage);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        // SizedBox(height: 10),
                                        // if (profilePic != null ||
                                        //     profilePhoto != null)
                                        //   GestureDetector(
                                        //     behavior:
                                        //         HitTestBehavior.translucent,
                                        //     child: Row(
                                        //       children: [
                                        //         CircleAvatar(
                                        //           radius: 22,
                                        //           backgroundColor:
                                        //               Colors.grey.shade300,
                                        //           child: Icon(
                                        //             Icons.close,
                                        //             size: 26,
                                        //             color: Colors.black,
                                        //           ),
                                        //         ),
                                        //         SizedBox(width: 15),
                                        //         Text("Remove photo",
                                        //             style: TextStyle(
                                        //                 fontSize: 18,
                                        //                 color: Colors.black)),
                                        //       ],
                                        //     ),
                                        //     onTap: () async {
                                        //       setState(() {
                                        //         // profilePhoto = null;
                                        //         profilePic = null;
                                        //       });
                                        //       Navigator.pop(context);
                                        //     },
                                        //   ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: profilePic == null
                          ? snapshot.data!['profilephoto'] != null
                              ? Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(snapshot
                                                      .data!['profilephoto']),
                                                  fit: BoxFit.cover)),
                                          child: null)))
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        color: light,
                                        child: Center(
                                          child: Text(
                                            snapshot.data!['name']
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )))
                          : Center(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: FileImage(profilePic),
                                              fit: BoxFit.cover)),
                                      child: null))),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ProfileMenu(
                      text: "Help & Feedback",
                      press: () {},
                    ),
                    ProfileMenu(
                      text: "Settings",
                      press: () {},
                    ),
                    ProfileMenu(
                      text: "Sign out",
                      press: () async {
                        FirebaseAuth.instance.signOut();
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('email');
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => SignIn()),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                );
              })),
        ));
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: veryLight,
        ),
        onPressed: press,
        child: Row(
          children: [
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
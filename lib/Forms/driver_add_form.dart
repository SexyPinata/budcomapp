import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Models/driver_model.dart';

String? _globalRoute;
String? name2;
String? email2;
String? number2;
String? photo2;
String? role2;
DocumentReference? route2;

/// This is the stateful widget that the main application instantiates.
class Driver_add_form extends StatefulWidget {
  const Driver_add_form({Key? key}) : super(key: key);

  @override
  State<Driver_add_form> createState() => _Driver_add_formState();
}

bool _load = false;
enum ImageSourceType { gallery, camera }

/// This is the private State class that goes with Driver_add_form.
class _Driver_add_formState extends State<Driver_add_form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Driver_Model model = Driver_Model(
      name: 'name',
      email: 'email',
      number: 'number',
      photo: 'photo',
      role: 'role',
      route: FirebaseFirestore.instance
          .collection('Routes')
          .doc('ZlumZXvBJqZEDzgfnyPl'));
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  //CollectionReference users = FirebaseFirestore.instance.collection('users');
  late String fileName;
  File? imageFile;
  PickedFile? pickedImage;
  Future<void> _picker(String inputSource) async {
    pickedImage;
    try {
      pickedImage = await ImagePicker().getImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 60);

      fileName = path.basename(pickedImage!.path);
      setState(() {
        imageFile = File(pickedImage!.path);
        _upload();
      });
    } catch (err) {
      print(err);
    }
  }

  Future<void> _upload() async {
    try {
      // Uploading the selected image with some custom meta data
      await storage.ref(fileName).putFile(imageFile!);
      await storage.ref(fileName).getDownloadURL().then((url) => {
            photo2 = url,
          });
      // Refresh the UI
      setState(() {});
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Name field
            TextFormField(
              onSaved: (value) async {
                name2 = value!;
              },
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              onSaved: (value) async {
                email2 = value!;
              },
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              onSaved: (value) async {
                number2 = value!;
              },
              decoration: const InputDecoration(
                hintText: 'Phone Number',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ), ////// Simple Dialog.
            ListTile(
              leading: imageFile == null
                  ? Text('not loaded')
                  : Image.file(
                      imageFile!,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        // Appropriate logging or analytics, e.g.
                        // myAnalytics.recordError(
                        //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                        //   exception,
                        //   stackTrace,
                        // );
                        return const Text('😢');
                      },
                    ),
              trailing: ElevatedButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                      title: const Text('Select Image'),
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: const Text('Gallery'),
                          onTap: () {
                            Navigator.pop(context, 'gallery');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: const Text('Camera'),
                          onTap: () {
                            Navigator.pop(context, 'camera');
                          },
                        ),
                      ],
                    ),
                  ).then((returnVal) async {
                    if (returnVal != null) {
                      await _picker(returnVal);
                      _load = true;
                    }
                  });
                },
                child: const Text('Photo'),
              ),
            ),
            const GetRoutes(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      _formKey.currentState!.save();
                      await _upload();
                      String refString = '';
                      await FirebaseFirestore.instance
                          .collection('Routes')
                          .where('Name', isEqualTo: _globalRoute)
                          .get()
                          .then((querySnapshot) {
                        for (var result in querySnapshot.docs) {
                          refString = result.id;
                        }
                      });
                      route2 = FirebaseFirestore.instance
                          .collection('Routes')
                          .doc(refString);
                      final docAddRef = FirebaseFirestore.instance
                          .collection('drivers')
                          .withConverter<Driver_Model>(
                            fromFirestore: (snapshot, _) =>
                                Driver_Model.fromJson(snapshot.data()!),
                            toFirestore: (newDriver, _) => newDriver.toJson(),
                          );
                      await docAddRef.add(Driver_Model(
                          name: name2!,
                          email: email2!,
                          number: number2!,
                          photo: photo2!,
                          role: 'User',
                          route: route2!));
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetRoutes extends StatefulWidget {
  const GetRoutes({Key? key}) : super(key: key);

  @override
  _Getroutes createState() => _Getroutes();
}

class _Getroutes extends State<GetRoutes> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Routes').snapshots();

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Halmstad';
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return DropdownButtonFormField<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          items: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> value =
                document.data()! as Map<String, dynamic>;
            return DropdownMenuItem<String>(
              value: value['Name'],
              child: Text(value['Name']),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            setState(() {
              dropdownValue = newValue!;
              _globalRoute = newValue;
            });
          },
        );
      },
    );
  }
}

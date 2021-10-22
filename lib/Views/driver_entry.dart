// @dart=2.9
import 'dart:io';

import 'package:budcomapp/Models/driver_model.dart';
import 'package:budcomapp/Providers/driver_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DriverEntryScreen extends StatefulWidget {
  Driver_Model entry;

  // ignore: use_key_in_widget_constructors
  DriverEntryScreen({this.entry});

  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<DriverEntryScreen> {
  final entryController = TextEditingController();
  final entryNameController = TextEditingController();
  final entryEmailController = TextEditingController();
  final entryPhoneController = TextEditingController();
  final entryRoleController = TextEditingController();
  bool editMode = false;
  @override
  void dispose() {
    entryController.dispose();
    entryNameController.dispose();
    entryEmailController.dispose();
    entryPhoneController.dispose();
    entryRoleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final entryProvider = Provider.of<DriverProvider>(context, listen: false);
    if (widget.entry != null) {
      //Edit
      entryController.text = widget.entry.email;
      entryNameController.text = widget.entry.name;
      entryPhoneController.text = widget.entry.number;
      entryRoleController.text = widget.entry.role;

      entryProvider.loadAll(widget.entry);
    } else {
      //Add
      entryProvider.loadAll(null);
    }
    super.initState();
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String fileName;
  File imageFile;
  PickedFile pickedImage;
  Future<void> _picker(String inputSource) async {
    pickedImage;
    try {
      pickedImage = await ImagePicker().getImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 60);

      fileName = path.basename(pickedImage.path);
      setState(() {
        imageFile = File(pickedImage.path);
      });
    } catch (err) {
      print(err);
    }
  }

  Future<String> _upload() async {
    try {
      String _url;
      // Uploading the selected image with some custom meta data
      await storage.ref(fileName).putFile(imageFile);
      await storage.ref(fileName).getDownloadURL().then((url) => {
            _url = url,
          });
      // Refresh the UI
      setState(() {});
      return _url;
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget _build(BuildContext context) {
    final entryProvider = Provider.of<DriverProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(entryProvider.name), actions: [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            _displayTextInputDialog(context).then((value) {
              if (value != null) {
                entryProvider.changeName = value;
              }
            });
          },
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Daily Entry',
                border: InputBorder.none,
              ),
              maxLines: 12,
              minLines: 10,
              onChanged: (String value) => entryProvider.changeName = value,
              controller: entryController,
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              onPressed: () {
                entryProvider.saveEntry();
                Navigator.of(context).pop();
              },
            ),
            (widget.entry != null)
                ? RaisedButton(
                    color: Colors.red,
                    child:
                        Text('Delete', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      entryProvider.removeEntry(widget.entry.id);
                      Navigator.of(context).pop();
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = Provider.of<DriverProvider>(context);
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                avatar: CachedNetworkImage(
                  imageUrl: entryProvider.photo,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                coverImage: CachedNetworkImage(
                  imageUrl: entryProvider.photo,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                title: entryProvider.name ?? '',
                subtitle: entryProvider.role,
                actions: <Widget>[
                  editMode
                      ? MaterialButton(
                          color: Colors.redAccent,
                          shape: CircleBorder(),
                          elevation: 0,
                          child: Icon(Icons.save),
                          onPressed: () {
                            setState(() {
                              editMode = !editMode;
                            });
                          },
                        )
                      : MaterialButton(
                          color: Colors.redAccent,
                          shape: CircleBorder(),
                          elevation: 0,
                          child: Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              editMode = !editMode;
                            });
                          },
                        )
                ],
              ),
              const SizedBox(height: 10.0),
              _UserInfo(context),
              _UserInfo(context),
            ],
          ),
        ));
  }

  Widget _UserInfo(BuildContext context) {
    final entryProvider = Provider.of<DriverProvider>(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Text(
              "User Information",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                            leading: Icon(Icons.text_fields),
                            title: Text("Name"),
                            subtitle: editMode
                                ? TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0))),
                                    ),
                                    onChanged: (String value) =>
                                        entryProvider.changeName = value,
                                    controller: entryNameController,
                                  )
                                : Text(entryProvider.name ?? ''),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text("Email"),
                            subtitle: editMode
                                ? TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0))),
                                    ),
                                    onChanged: (String value) =>
                                        entryProvider.changeEmail = value,
                                    controller: entryEmailController,
                                  )
                                : Text(entryProvider.email ?? ''),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone),
                            title: Text("Phone"),
                            subtitle: editMode
                                ? TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0))),
                                    ),
                                    onChanged: (String value) =>
                                        entryProvider.changeNumber = value,
                                    controller: entryPhoneController,
                                  )
                                : Text(entryProvider.number ?? ''),
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text("Role"),
                            subtitle: editMode
                                ? TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0))),
                                    ),
                                    onChanged: (String value) =>
                                        entryProvider.changeRole = value,
                                    controller: entryRoleController,
                                  )
                                : Text(entryProvider.role ?? ''),
                          ),
                          ListTile(
                            leading: Icon(Icons.location_city),
                            title: Text("Location"),
                            subtitle: Text("Sweden"),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<String> _displayTextInputDialog(BuildContext context) async {
    String valueText;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: entryController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  return valueText;
                },
              ),
            ],
          );
        });
  }
}

class ProfileHeader extends StatelessWidget {
  final CachedNetworkImage coverImage;
  final CachedNetworkImage avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key key,
      this.coverImage,
      this.avatar,
      this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          child: coverImage,
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 40,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final CachedNetworkImage image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          child: image,
        ),
      ),
    );
  }
}

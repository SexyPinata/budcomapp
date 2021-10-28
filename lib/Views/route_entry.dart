// @dart=2.9
import 'dart:io';
import 'dart:math';

import 'package:budcomapp/Models/ap_model.dart';
import 'package:budcomapp/Models/driver_model.dart';
import 'package:budcomapp/Models/route_model.dart';
import 'package:budcomapp/Providers/accesspoint_provider.dart';
import 'package:budcomapp/Providers/driver_provider.dart';
import 'package:budcomapp/Providers/route_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_blurhash/flutter_blurhash.dart';

class RouteEntryScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  RouteEntryScreen({this.entry});

  Route_Model entry;

  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<RouteEntryScreen> {
  bool editMode = false;
  final entryController = TextEditingController();
  final entryEmailController = TextEditingController();
  final entryNameController = TextEditingController();
  final entryPhoneController = TextEditingController();
  final entryRoleController = TextEditingController();
  String fileName;
  File imageFile;
  bool isImagePicked = false;
  PickedFile pickedImage;
  List<dynamic> _selectedAps = [];
  List<ApModelMini> _apMiniList = [];
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

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
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);

    if (widget.entry != null) {
      //Edit
      _selectedAps = widget.entry.list_of_aps;
      print(_selectedAps);
      _apMiniList = List<ApModelMini>.from(
          _selectedAps.map((e) => ApModelMini.fromMap(e)));
      entryNameController.text = widget.entry.name;

      routeProvider.loadAll(widget.entry);
    } else {
      //Add
      routeProvider.loadAll(null);
    }
    super.initState();
  }

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
        isImagePicked = true;
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

  // ignore: non_constant_identifier_names
  Widget _RouteInfo(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);
    final accessPointProvider = Provider.of<AccessPointProvider>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: const Text(
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                            leading: const Icon(Icons.location_city),
                            title: const Text("Route Name"),
                            subtitle: editMode
                                ? TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                    ),
                                    onChanged: (String value) =>
                                        routeProvider.changeName = value,
                                    controller: entryNameController,
                                  )
                                : Text(routeProvider.name ?? ''),
                          ),
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: const Text("Access Points"),
                            subtitle: editMode
                                ? StreamBuilder<List<ApModel>>(
                                    stream: accessPointProvider.entries,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Something went wrong');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text("Loading");
                                      }

                                      return MultiSelectDialogField(
                                        buttonText: Text('Access Points'),
                                        buttonIcon:
                                            const Icon(Icons.arrow_downward),
                                        unselectedColor: Colors.white,
                                        selectedColor: Colors.redAccent,
                                        selectedItemsTextStyle:
                                            TextStyle(color: Colors.redAccent),
                                        //backgroundColor: Colors.white,
                                        itemsTextStyle:
                                            TextStyle(color: Colors.white),
                                        items: snapshot.data.map((accessPoint) {
                                          return MultiSelectItem<ApModel>(
                                            accessPoint,
                                            accessPoint.name,
                                          );
                                        }).toList(),

                                        onConfirm: (List<ApModel>
                                            selectedAccessPoints) {
                                          _apMiniList == null
                                              ? null
                                              : _apMiniList.clear();
                                          for (var item
                                              in selectedAccessPoints) {
                                            _apMiniList.add(ApModelMini(
                                                id: item.id, name: item.name));
                                          }
                                          _selectedAps = List<dynamic>.from(
                                              _apMiniList
                                                  .map((e) => e.toMap()));
                                          routeProvider.changeList_of_aps =
                                              _selectedAps;
                                        },
                                      );
                                    },
                                  )
                                : _selectedAps == null
                                    ? Text('')
                                    : Text(List<dynamic>.from(
                                            _apMiniList.map((e) => e.name))
                                        .join(', ')),
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

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context);
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  editMode
                      ? showDialog<String>(
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
                            setState(() {});
                          }
                        })
                      : null;
                },
                child: ProfileHeader(
                  coverImage: CachedNetworkImage(
                    imageUrl: 'entryProvider.photo',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => isImagePicked
                        ? Image.file(
                            imageFile,
                            alignment: Alignment.center,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : BlurHash(hash: "L5H2EC=PM+yV0g-mq.wG9c010J}I"),
                    errorWidget: (context, url, error) => isImagePicked
                        ? Image.file(
                            imageFile,
                            alignment: Alignment.center,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : BlurHash(hash: "L5H2EC=PM+yV0g-mq.wG9c010J}I"),
                  ),
                  title: routeProvider.name ?? '',
                  actions: <Widget>[
                    editMode
                        ? MaterialButton(
                            color: Colors.redAccent,
                            shape: CircleBorder(),
                            elevation: 0,
                            child: const Icon(Icons.save),
                            onPressed: () async {
                              routeProvider.saveEntry();
                              setState(() {
                                editMode = !editMode;
                              });
                            },
                          )
                        : MaterialButton(
                            color: Colors.redAccent,
                            shape: const CircleBorder(),
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
              ),
              const SizedBox(height: 10.0),
              _RouteInfo(context),
            ],
          ),
        ));
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(
      {Key key,
      this.gestureDetector,
      this.coverImage,
      this.avatar,
      this.title,
      this.subtitle,
      this.actions})
      : super(key: key);

  final List<Widget> actions;
  final CachedNetworkImage avatar;
  final CachedNetworkImage coverImage;
  final GestureDetector gestureDetector;
  final String subtitle;
  final String title;

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
  const Avatar(
      {Key key,
      this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final CachedNetworkImage image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        radius: radius + borderWidth,
        backgroundColor: borderColor,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          child: CircleAvatar(
            radius: radius - borderWidth,
            child: image,
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:b_wishes/constant/constant.dart';
import 'package:b_wishes/widgets/widget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MultiplePick extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;
  const MultiplePick({Key key, this.globalKey}) : super(key: key);
  @override
  _MultiplePickState createState() => _MultiplePickState();
}

class _MultiplePickState extends State<MultiplePick> {
  List<Asset> images = <Asset>[];
  List<String> imageUrls = <String>[];
  FirebaseFirestore _db = FirebaseFirestore.instance;
  String _error = 'No Error Dectected';

  @override
  void initState() {
    chargerJours();
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "BirthWish",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  var listJour = [];
  var currentJour = '1';
  var currentMois = 'Janvier';
  var _textValue = '';
  var _textValuePar = '';

  // var listMois = ;
  var listMois = <String>[
    'Janvier',
    'Fevrier',
    'Mars',
    'Avril',
    'Mais',
    'Juin',
    'Juillet',
    'Aout',
    'Septembre',
    'Octobre',
    'Novembre',
    'Decembre'
  ];

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference reference = storage.ref().child(fileName);
    firebase_storage.UploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());

    firebase_storage.TaskSnapshot storageTaskSnapshot = await uploadTask;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  void uploadImages(BuildContext context) {
    for (var imageFile in images) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          _db.collection('wishes').add({
            'urls': imageUrls,
            'pour': _textValue,
            'jour': currentJour,
            'mois': currentMois,
            'par': _textValuePar
          }).then((_) {
            setState(() {
              images = [];
              imageUrls = [];
            });

            showToast(
                bgColor: Colors.black,
                txtColor: Colors.white,
                message: 'Souhait enregistrer');
            Navigator.of(context).pop();
          });
          Navigator.of(context).pop();
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  void chargerJours() {
    for (int i = 1; i < 32; i++) {
      listJour.add(i.toString());
    }
    print(listJour);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: primaryPinkColor,
        title: Text(
          'BirthWish',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryRainBColor,
        child: Icon(
          Icons.cloud_upload,
          color: primarySnowColor,
        ),
        onPressed: () {
          if (images.length == 0) {
            showToast(
                bgColor: Colors.black,
                txtColor: Colors.white,
                message: 'Choisissez les images');
            return;
          }

          if (_textValue == '' || _textValuePar == '') {
            showToast(
                bgColor: Colors.black,
                txtColor: Colors.white,
                message: 'Saisissez les noms');
            return;
          }

          loadingDialog(context);
          uploadImages(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                  labelText: 'Votre nom',
                  hintStyle: TextStyle(color: primaryRainBColor)),
              onChanged: (value) {
                _textValuePar = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(labelText: 'Anniversaire de '),
              onChanged: (value) {
                _textValue = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('Mois :'),
                SizedBox(
                  width: 20,
                ),
                DropdownButton(
                  underline: Text(''),
                  focusColor: Colors.red,
                  onChanged: (newValue) {
                    setState(() {
                      currentMois = newValue;
                    });
                  },
                  value: currentMois,
                  items: listMois
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                ),
                SizedBox(
                  width: 20,
                ),
                Text('Jour :'),
                SizedBox(
                  width: 20,
                ),
                DropdownButton(
                  underline: Text(''),
                  onChanged: (newValue) {
                    setState(() {
                      currentJour = newValue;
                    });
                  },
                  value: currentJour,
                  items: listJour
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                color: primaryRainBColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: primarySnowColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Choisir les photos',
                      style: TextStyle(color: primarySnowColor),
                    )
                  ],
                ),
                onPressed: () {
                  //print(images);
                  loadAssets();
                }),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: buildGridView(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/views/merchant_home_view.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/user_home_view_model.dart';
import 'package:giver_app/service_locator.dart';
import 'package:giver_app/services/firebase_service.dart';
import 'package:image_picker/image_picker.dart';

class MerchantUpdateInfoView extends StatefulWidget {
  const MerchantUpdateInfoView({@required this.merchant});

  final User merchant;

  @override
  _MerchantUpdateInfoViewState createState() => _MerchantUpdateInfoViewState();
}

class _MerchantUpdateInfoViewState extends State<MerchantUpdateInfoView> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String _username, _address, _phone;
  var isEditProfileImage = false;
  File uploadFile;
  FirebaseService _firebaseService = locator<FirebaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: FlatButton(
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MerchantHomeView(
                        user: widget.merchant,
                      ))),
          child: Icon(Icons.arrow_back),
        ),
        title: new Text('Merchant Infomation'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            key: _key,
            autovalidate: _validate,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  _updateMerchantData() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      Firestore.instance
          .collection("users")
          .document(widget.merchant.id)
          .updateData({
        'username': _username,
        'phone': _phone,
        'address': _address,
      }).then(_navigateToMerchantHomeView());
    } else {
      _navigateToMerchantHomeView();
    }
  }

  _navigateToMerchantHomeView() {
    UserHomeViewModel model = locator<UserHomeViewModel>();
    User updatedUser =
        model.getCurrentUser(model.merchants, widget.merchant.id);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MerchantHomeView(
                  user: updatedUser,
                )));
  }

  String validate(String value) {
    if (value.length == 0) {
      return "Input can not be empty";
    }
    return null;
  }

  imageSelectorGallery() async {
    uploadFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      // maxHeight: 50.0,
      // maxWidth: 50.0,
    );
    print("You selected gallery image : " + uploadFile.path);
    setState(() {
      isEditProfileImage = true;
    });
  }

  imageSelectorCamera() async {
    uploadFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      // maxHeight: 50.0,
      // maxWidth: 50.0,
    );
    print("You took camera image : " + uploadFile.path);
    setState(() {
      isEditProfileImage = true;
    });
  }

  Future<bool> updateNewImage(
      StorageReference ref, BuildContext context) async {
    String uid = widget.merchant.id;
    print('start add new image');
    print('firename:');
    print(uid);
    StorageUploadTask uploadTask = ref.putFile(uploadFile);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    setState(() {
      isEditProfileImage = false;
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
    _firebaseService.editImageUrl(url, uid);

    return true;
  }

  Future uploadPic(BuildContext context) async {
    print('deleting old image && add new image process:');
    // reference to image file of current user
    StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profileImages/' + widget.merchant.id);

    if (firebaseStorageRef == null) {
      print('no old image to delete');
      updateNewImage(firebaseStorageRef, context);
    } else {
      // Delete the current image file
      await firebaseStorageRef.delete().catchError((error) {
        print('this error occur when delete file in Firebase Storage:');
        setState(() {
          isEditProfileImage = false;
          uploadFile = null;
        });
      }).whenComplete(() {
        print('comleted deleting old image');
      }).then((_) => updateNewImage(firebaseStorageRef, context));
      print('result add new Image is');
    }
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.camera_alt),
                    onPressed: () => imageSelectorCamera(),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  FlatButton(
                    child: Icon(Icons.photo_library),
                    onPressed: () => imageSelectorGallery(),
                  )
                ],
              ),
              flex: 3,
            ),
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  child: Container(
                    child: new SizedBox(
                      width: 190.0,
                      height: 190.0,
                      child: uploadFile == null
                          ? Image.network(
                              widget.merchant.imageUrl,
                              fit: BoxFit.fill,
                            )
                          : Image.file(
                              uploadFile,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  onTap: () => imageSelectorGallery(),
                ),
              ),
            ),
            Expanded(
              child: !isEditProfileImage
                  ? Text('')
                  : Column(
                      children: <Widget>[
                        FlatButton(
                          child: Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              uploadFile = null;
                            });
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        FlatButton(
                          child: Icon(Icons.check_box),
                          onPressed: () => uploadPic(context),
                        )
                      ],
                    ),
              flex: 1,
            ),
          ],
        ),
        new TextFormField(
          initialValue: widget.merchant.username,
          decoration: new InputDecoration(hintText: 'Username'),
          maxLength: 32,
          validator: validate,
          onSaved: (String val) {
            _username = val;
          },
        ),
        new TextFormField(
            initialValue: widget.merchant.phone,
            decoration: new InputDecoration(hintText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: validate,
            onSaved: (String val) {
              _phone = val;
            }),
        new TextFormField(
            initialValue: widget.merchant.address,
            decoration: new InputDecoration(hintText: 'Address'),
            maxLength: 32,
            validator: validate,
            onSaved: (String val) {
              _address = val;
            }),
        new SizedBox(height: 15.0),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _updateMerchantData,
              child: new Text('Update'),
            ),
            Container(
              width: 20,
            ),
            RaisedButton(
              onPressed: _navigateToMerchantHomeView,
              child: new Text('Cancel'),
            )
          ],
        )
      ],
    );
  }
}

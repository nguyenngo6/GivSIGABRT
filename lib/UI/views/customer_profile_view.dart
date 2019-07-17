import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:giver_app/UI/widgets/busy_overlay.dart';
import 'package:giver_app/model/user.dart';
import 'package:giver_app/scoped_model/customer_profile_view_model.dart';
import 'package:giver_app/enum/view_state.dart';
import 'package:image_picker/image_picker.dart';
import 'base_view.dart';
import 'customer_home_view.dart';

class CustomerProfileView extends StatefulWidget {
  final User user;
  CustomerProfileView({@required this.user});

  @override
  _CustomerProfileViewState createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  //save the result of gallery file
  File galleryFile;
  var isEditProfileImage = false;

//save the result of camera file
  File cameraFile;

  @override
  Widget build(BuildContext context) {

    Future<bool> updateNewImage(StorageReference ref, BuildContext context, CustomerProfileViewModel model) async{
      String uid = widget.user.id;
      print('start add new image');
      print('firename:');
      print(uid);
      StorageUploadTask uploadTask = ref.putFile(galleryFile);

      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      String url = dowurl.toString();
      setState(() {
        isEditProfileImage = false;
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
      model.onInfoEdited(url, uid);
      return true;
    }

    Future uploadPic(BuildContext context, CustomerProfileViewModel model) async {
      model.setState(ViewState.EditImageUrl);
      print('deleting old image && add new image process:');
      // reference to image file of current user
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('profileImages/' + widget.user.id);
      
      if (firebaseStorageRef != null) {
        print('no old image to delete');
        updateNewImage(firebaseStorageRef, context, model);
      }else{
        // Delete the current image file
        bool result = await firebaseStorageRef.delete().catchError((error){
          print('this error occur when delete file in Firebase Storage:'+ error);
          setState(() {
            isEditProfileImage = false;
            galleryFile = null;
          });
        }).whenComplete((){
          print('comleted deleting old image');
        }).then((_)=>updateNewImage(firebaseStorageRef, context, model));

        print('result deleting is: $result');
      }

    }

    imageSelectorGallery() async {
      galleryFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        // maxHeight: 50.0,
        // maxWidth: 50.0,
      );
      print("You selected gallery image : " + galleryFile.path);
      setState(() {
        isEditProfileImage = true;
      });
    }
    Widget _buildAvatar(BuildContext context,CustomerProfileViewModel model, String url) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(''),
            flex: 2,
          ),
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Color(0xff476cfb),
                  child: ClipOval(
                    child: new SizedBox(
                      width: 190.0,
                      height: 190.0,
                      child: galleryFile == null
                          ? Image.network(
                              url,
                              fit: BoxFit.fill,
                            )
                          : Image.file(
                              galleryFile,
                              fit: BoxFit.fill,
                            ),
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
                            galleryFile = null;
                          });
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      FlatButton(
                        child: Icon(Icons.check_box),
                        onPressed: () => uploadPic(context, model),
                      )
                    ],
                  ),
            flex: 2,
          ),
        ],
      );
    }
    onSubmit(String input, CustomerProfileViewModel model) async {
      await model.onInfoEdited(input, widget.user.id);
    }

    Widget _getCenteredViewMessage(
        BuildContext context, String message, CustomerProfileViewModel model,
        {bool error = false}) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    message,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  error
                      ? Icon(
                          // WWrap in gesture detector and call you refresh future here
                          Icons.refresh,
                          color: Colors.white,
                          size: 45.0,
                        )
                      : Container()
                ],
              )));
    }

    Widget _noDataUi(BuildContext context, CustomerProfileViewModel model) {
      return _getCenteredViewMessage(context, "No data available yet", model);
    }

    Widget _errorUi(BuildContext context, CustomerProfileViewModel model) {
      return _getCenteredViewMessage(
          context, "Error retrieving your data. Tap to try again", model,
          error: true);
    }
    Widget _getCustomerProfile(
        BuildContext context, CustomerProfileViewModel model) {
      User currentUser = model.getCurrentUser(model.customers, widget.user.id);
      return SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 20.0,
                ),
                _buildAvatar(context,model, currentUser.imageUrl),
                ListTile(
                  leading: Icon(Icons.people),
                  title: model.state == ViewState.EditUsername
                      ? TextFormField(
                          onFieldSubmitted: (input) => onSubmit(input, model),
                          initialValue: currentUser.username,
                        )
                      : Text(currentUser.username,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                  trailing: FlatButton(
                      onPressed: () => model.setState(ViewState.EditUsername),
                      child: Icon(Icons.edit)),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(currentUser.email),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: model.state != ViewState.EditPhone
                      ? Text(currentUser.phone)
                      : TextFormField(
                          onFieldSubmitted: (input) => onSubmit(input, model),
                          initialValue: currentUser.phone,
                        ),
                  trailing: FlatButton(
                      onPressed: () => model.setState(ViewState.EditPhone),
                      child: Icon(Icons.edit)),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget _getBodyUi(BuildContext context, CustomerProfileViewModel model) {
      switch (model.state) {
        case ViewState.NoDataAvailable:
          return _noDataUi(context, model);
        case ViewState.Error:
          return _errorUi(context, model);
        case ViewState.DataFetched:
        default:
          return _getCustomerProfile(context, model);
      }
    }

    return BaseView<CustomerProfileViewModel>(
      builder: (context, child, model) => BusyOverlay(
        show: model.state == ViewState.Busy,
        child: Scaffold(
          appBar: AppBar(
            leading: FlatButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerHomeView(user: widget.user))),
                child: Icon(Icons.backspace)),
            title: Text("title"),
            actions: <Widget>[
              Center(
                child: Text(
                  "CREDIT",
                ),
              ),
              Center(
                  child: Text(
                widget.user.points.toString(),
                style: TextStyle(color: Colors.red, fontSize: 25),
              )),
              Center(child: IconButton(icon: Icon(Icons.credit_card))),
            ],
          ),
          body: Builder(builder: (context) => _getBodyUi(context, model)),
        ),
      ),
    );
  }
}
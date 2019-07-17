import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/model/coupon.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/user.dart';
import 'package:meta/meta.dart';

class FirebaseService {
  final StreamController<List<User>> _userController =
      StreamController<List<User>>.broadcast();

  final StreamController<List<User>> _merchantController =
      StreamController<List<User>>.broadcast();

  final StreamController<List<Charity>> _charityController =
      StreamController<List<Charity>>.broadcast();

  final StreamController<List<User>> _customerController =
      StreamController<List<User>>.broadcast();

  final StreamController<List<Coupon>> _couponController =
      StreamController<List<Coupon>>.broadcast();

  FirebaseService() {
    Firestore.instance.collection('users').snapshots().listen(_userAdded);

    Firestore.instance.collection('coupons').snapshots().listen(_couponAdded);

    Firestore.instance
        .collection('charities')
        .snapshots()
        .listen(_charityAdded);
  }

  Stream<List<Coupon>> get coupons => _couponController.stream;

  Stream<List<User>> get users => _userController.stream;

  Stream<List<User>> get customers => _customerController.stream;

  Stream<List<User>> get merchants => _merchantController.stream;

  Stream<List<Charity>> get charities => _charityController.stream;

//  void getCustomerByUid({String uid}) {
//    Firestore.instance.collection('users').document(uid).snapshots().listen(_customerInfoAdded);
//  }

  void redeemCoupon({@required String couponID}) {
    Firestore.instance
        .collection("coupons")
        .document(couponID)
        .updateData({'isUsed': true});
  }

  void _couponAdded(QuerySnapshot snapshot) {
    var coupon = _getCouponFromSnapshot(snapshot);
    _couponController.add(coupon);
  }

  List<Coupon> _getCouponFromSnapshot(QuerySnapshot snapshot) {
    var couponList = List<Coupon>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        couponList.add(Coupon.fromData(documentData));
      }
    }

    return couponList;
  }

  void _userAdded(QuerySnapshot snapshot) {
    var merchant = _getMerchantFromSnapshot(snapshot);
    var customer = _getCustomerFromSnapshot(snapshot);
    var user = _getUserFromSnapshot(snapshot);
    _merchantController.add(merchant);
    _customerController.add(customer);
    _userController.add(user);
  }

  List<User> _getUserFromSnapshot(QuerySnapshot snapshot) {
    var userList = List<User>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        userList.add(User.fromData(documentData));
      }
    }
    return userList;
  }

  List<User> _getCustomerFromSnapshot(QuerySnapshot snapshot) {
    var customerList = List<User>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        if (documentData['level'] == 1) {
          documentData['id'] = document.documentID;
          customerList.add(User.fromData(documentData));
        }
      }
    }
    return customerList;
  }

  List<User> _getMerchantFromSnapshot(QuerySnapshot snapshot) {
    var merchantList = List<User>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        if (documentData['level'] == 2) {
          documentData['id'] = document.documentID;
          merchantList.add(User.fromData(documentData));
        }
      }
    }
    return merchantList;
  }

  void _charityAdded(QuerySnapshot snapshot) {
    var charity = _getCharityFromSnapshot(snapshot);
    _charityController.add(charity);
  }

  List<Charity> _getCharityFromSnapshot(QuerySnapshot snapshot) {
    var charityList = List<Charity>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        charityList.add(Charity.fromData(documentData));
      }
    }
    return charityList;
  }

  Future<bool> editPhone(String newPhone, String uid) async {
    DocumentReference reference =
    await Firestore.instance.collection('users').document(uid);
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);

      await transaction
          .update(snapshot.reference, {"phone": newPhone});
    });
    return true;
  }

  Future<bool> editImageUrl(String newImageUrl, String uid) async {
    DocumentReference reference =
    await Firestore.instance.collection('users').document(uid);
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);

      await transaction
          .update(snapshot.reference, {"imageUrl": newImageUrl});
    });
    return true;
  }


  Future<bool> editUsername(String newUsername, String uid) async {
    DocumentReference reference =
        await Firestore.instance.collection('users').document(uid);
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = await transaction.get(reference);

      await transaction
          .update(snapshot.reference, {"username": newUsername});
    });
    return true;
  }
}

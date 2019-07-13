import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:giver_app/model/charity.dart';
import 'package:giver_app/model/user.dart';

class FirebaseService {
  final StreamController<List<User>> _merchantController =
      StreamController<List<User>>();

  final StreamController<List<Charity>> _charityController =
      StreamController<List<Charity>>();

  final StreamController<List<User>> _customerController =
  StreamController<List<User>>();

  FirebaseService() {
    Firestore.instance
        .collection('users')
        .where("level", isEqualTo: 2)
        .snapshots()
        .listen(_merchantAdded);

    Firestore.instance
        .collection('charities')
        .snapshots()
        .listen(_charityAdded);
  }

  Stream<List<User>> get customers => _customerController.stream;


  Stream<List<User>> get merchants => _merchantController.stream;

  Stream<List<Charity>> get charities => _charityController.stream;

//  void getCustomerByUid({String uid}) {
//    Firestore.instance.collection('users').document(uid).snapshots().listen(_customerInfoAdded);
//  }

  void _customerAdded(QuerySnapshot snapshot) {
    var customer = _getCustomerFromSnapshot(snapshot);
    _merchantController.add(customer);
  }

  List<User> _getCustomerFromSnapshot(QuerySnapshot snapshot) {
    var customerList = List<User>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        customerList.add(User.fromData(documentData));
      }
    }
    return customerList;
  }

  void _merchantAdded(QuerySnapshot snapshot) {
    var merchant = _getMerchantFromSnapshot(snapshot);
    _merchantController.add(merchant);
  }

  List<User> _getMerchantFromSnapshot(QuerySnapshot snapshot) {
    var merchantList = List<User>();
    var documents = snapshot.documents;
    if (documents.length > 0) {
      for (var document in documents) {
        var documentData = document.data;
        documentData['id'] = document.documentID;
        merchantList.add(User.fromData(documentData));
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
}

const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.myFunctionName = functions.firestore
    .document('bank/creditBank/donate/{donateId}').onCreate((snap, context) => {
                                                         // Get an object representing the document
                                                         // e.g. {'name': 'Marie', 'age': 66}
                                                         const newValue = snap.data();

                                                         // access a particular field as you would any JS property
                                                         const name = newValue.name;

                                                         // perform desired operations ...
                                                       });

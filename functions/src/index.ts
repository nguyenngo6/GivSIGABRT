import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp(functions.config().firebase);
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

const db = admin.firestore();
const fcm = admin.messaging();

export const user = functions.https.onRequest((request, response) => {
    const userID = request.path;
    admin.firestore().collection('users').doc(userID).get().then(result => {
        response.send(result.data());
    }).catch(error => {
        response.send(error);
    })
});

export const sendToDevice = functions.firestore
  .document('coupons/12345')
  .onCreate(async snapshot => {


    const coupon = snapshot.data()!;

    const querySnapshot = await db
      .collection('users')
      .doc(coupon.ownedBy)
      .collection('tokens')
      .get();

    const tokens = querySnapshot.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Coupon!',
        body: `you created a ${coupon.code} coupon`,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };
    console.log(coupon.ownedBy);

    return fcm.sendToDevice(tokens, payload);
  });
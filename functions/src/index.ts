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


export const sendAprrovalNotification = functions.firestore
  .document('coupons/{couponID}')
  .onUpdate(async snapshot => {
    const old = snapshot.before.data()!;
    const coupon = snapshot.after.data()!;

    if (old.isPending == false && coupon.isPending == true) {
      const querySnapshot = await db
        .collection('users')
        .doc(coupon.ownedBy)
        .collection('tokens')
        .get();

      const documentSnapshot = await db
        .collection('users')
        .doc(coupon.usedBy).get();

      const customer = documentSnapshot.data()!;

      const tokens = querySnapshot.docs.map(snap => snap.id);

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: 'Coupon Aprroval Needed',
          body: `Coupon: ${coupon.code}\nUsed by: ${customer.username}`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        },
        data: {
          cId: `${snapshot.before.id}`,
          tag: `approval`,
        }
      };
      return fcm.sendToDevice(tokens, payload);
    };

    return null;


  });


export const sendCouponNotification = functions.firestore
  .document('coupons/{couponID}')
  .onUpdate(async snapshot => {

    const old = snapshot.before.data()!;
    const coupon = snapshot.after.data()!;

    if (old.isUsed == false && coupon.isUsed == true) {
      const querySnapshot = await db
        .collection('users')
        .doc(coupon.usedBy)
        .collection('tokens')
        .get();

      const documentSnapshot = await db
        .collection('users')
        .doc(coupon.ownedBy).get();

      const merchant = documentSnapshot.data()!;

      const tokens = querySnapshot.docs.map(snap => snap.id);

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: 'Coupon Aprroved',
          body: `The coupon ${coupon.code} has been approved by ${merchant.username}`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        },
        data: {
          cId: `${snapshot.before.id}`,
          tag: `updateNotify`,
          
        }
        
      };
      tokens.forEach(function (value)  {
        return fcm.sendToDevice(value, payload);
      });
    };  

    return null;
  });

  export const approveCoupon = functions.https.onCall(async (data, context) => {
    try {
      const couponID = data.couponID;
      const coupon = await db
        .collection('coupons').doc(couponID).update({
          'isUsed': true,
        });
    } catch (error) {
  
    }
  
  
  
  });
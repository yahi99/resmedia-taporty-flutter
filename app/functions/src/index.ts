// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

import { addPaymentSource, createStripeCharge, createStripeCustomer, cleanupUser,updateState,setShift,updateUser,updateOffersEmail,updateOffersSms,updateOffersApp,updateNotifySms,updateNotifyApp,updateNotifyEmail} from './lib';

 // Start writing Firebase Functions
 // https://firebase.google.com/docs/functions/typescript
 // firebase deploy
 // firebase deploy --only functions
 // npm install @google-cloud/firestore

exports.updateState = updateState;
exports.createStripeCustomer = createStripeCustomer;
exports.cleanupUser = cleanupUser
// Aggiungere carta
exports.addPaymentSource = addPaymentSource;
exports.createStripeCharge = createStripeCharge;
exports.setShift=setShift;
exports.updateUser=updateUser;
exports.updateNotifyEmail=updateNotifyEmail;
exports.updateNotifySms=updateNotifySms;
exports.updateNotifyApp=updateNotifyApp;
exports.updateOffersEmail=updateOffersEmail;
exports.updateOffersSms=updateOffersSms;
exports.updateOffersApp=updateOffersApp;
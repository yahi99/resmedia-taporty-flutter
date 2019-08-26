import * as functions from 'firebase-functions';
// tslint:disable-next-line: no-implicit-dependencies
import * as Stripe from 'stripe';
import { fs } from './firebase';

// tslint:disable-next-line: no-use-before-declare
export { createStripeCustomer, cleanupUser, createStripeCharge, addPaymentSource, updateState, setShift,updateUser,updateOffersEmail,updateOffersSms,updateOffersApp,updateNotifySms,updateNotifyApp,updateNotifyEmail  }
const stripe = new Stripe(functions.config().stripe.token);
const currency = 'EUR'

const createStripeCustomer = functions.auth.user().onCreate(async (user, context) => {
  const customer = await stripe.customers.create({email: user.email});
  return fs.collection('stripe_customers').doc(user.uid).set({customer_id: customer.id});
});


// When a user deletes their account, clean up after them
const cleanupUser = functions.auth.user().onDelete(async (user) => {
  const snap = await fs.collection('stripe_customers').doc(user.uid).get();
  const customerData = snap.data();
  await stripe.customers.del(customerData!.customer_id);
  return fs.collection('stripe_customers').doc(user.uid).delete();
});

const addPaymentSource = functions.https.onCall(async (data, context) => {
  const token = data!.token;
  const customerData = (await fs.collection('stripe_customers').doc(context.auth!.uid).get()).data();
  const customer =  customerData!.customer_id;
  const response = await stripe.customers.createSource(customer, {source: token}, {api_key: functions.config().stripe.token});
  const mapResponse = (response as {[field:string]: any})
  const fingerPrint = mapResponse['card']['fingerprint']
  console.log("sourceId", fingerPrint)
  mapResponse.token = token
  await fs.collection('stripe_customers').doc(context.auth!.uid)
          .collection("sources").doc(fingerPrint)
          .create(response);
  return {"documentId": fingerPrint,}
});

const updateState = functions.https.onCall(async (data, context) => {
  const state=data.state;
  const rid=data.rid;
  const oid=data.oid;
  await fs.collection('restaurants').doc(rid).collection('orders').doc(oid).update({'state':state});
  return {"documentId": "id",}
});

const updateUser = functions.https.onCall(async (data, context) => {
  const uid=data.uid;
  const email=data.email;
  const nominative=data.nominative;
  await fs.collection('users').doc(uid).update({'email':email,'nominative':nominative});
  return {"documentId": "id",}
});

const updateNotifyEmail = functions.https.onCall(async (data, context) => {
  const uid=data.uid;
  const notifyEmail=data.notifyEmail;
  await fs.collection('users').doc(uid).update({'notifyEmail':notifyEmail});
  return {"documentId": "id",}
});

const updateNotifySms = functions.https.onCall(async (data, context) => {
  const uid=data.uid;
  const notifySms=data.notifySms;
  await fs.collection('users').doc(uid).update({'notifySms':notifySms});
  return {"documentId": "id",}
});

const updateNotifyApp = functions.https.onCall(async (data, context) => {
  const uid=data.uid;
  const notifyApp=data.notifyApp;
  await fs.collection('users').doc(uid).update({'notifyApp':notifyApp});
  return {"documentId": "id",}
});

const updateOffersEmail = functions.https.onCall(async (data, context) => {
  const uid=data.uid;
  const offersEmail=data.offersEmail;
  await fs.collection('users').doc(uid).update({'offersEmail':offersEmail});
  return {"documentId": "id",}
});

const updateOffersSms = functions.https.onCall(async (data, context) => {
  const uid=data.uid;
  const offersSms=data.offersSms;
  await fs.collection('users').doc(uid).update({'offersSms':offersSms});
  return {"documentId": "id",}
});

const updateOffersApp = functions.https.onCall(async (data, context) => {
  const uid=data.uid;
  const offersApp=data.offersApp;
  await fs.collection('users').doc(uid).update({'offersApp':offersApp});
  return {"documentId": "id",}
});

const setShift = functions.https.onCall(async (data, context) => {
  const uid=data.uid;
  const users=data.users;
  const startTime=data.startTime;
  const endTime=data.endTime;
  const day=data.day;
  const month=data.month;
  await fs.collection('days').doc(day).collection('times').doc(startTime).update({'users':users});
  await fs.collection('users').doc(uid).collection('turns').doc(day).create({'startTime':startTime,'endTime':endTime,'day':day,'month':month});
  return {"documentId": "id",}
});


//Creazione pagamento
const createStripeCharge = functions.firestore
.document('stripe_customers/{userId}/charges/{id}')
.onCreate(async (snap, context) => {
  try {
    const chargeData = snap.data();
    const customerData = (await snap.ref.parent.parent!.get()).data();
    const customer = customerData!.customer_id
    const amount = chargeData!.amount;
    const idempotencyKey = context.params.id;
    const charge: Stripe.charges.IChargeCreationOptions = {amount, currency, customer};
    if (chargeData!.source) {
      charge.source = chargeData!.source;
    }
    const response = await stripe.charges.create(charge, {idempotency_key: idempotencyKey});
    return snap.ref.set(response, { merge: true });
  } catch(error) {
    console.log(error);
    return
    //await snap.ref.set({error: userFacingMessage(error)}, { merge: true });
    //return reportError(error, {user: context.params.userId});
  }
});
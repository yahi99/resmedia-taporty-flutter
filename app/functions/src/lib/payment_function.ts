import * as functions from 'firebase-functions';
// tslint:disable-next-line: no-implicit-dependencies
import * as Stripe from 'stripe';
import { firestore, messaging } from './firebase';
import * as admin from 'firebase-admin'

// tslint:disable-next-line: no-use-before-declare
export { createStripeCustomer, cleanupUser, createStripeCharge, addPaymentSource, createUser, updateState, sendToDeviceDriver, sendToDeviceSupplier, productRequests, supplierRequests, setShift, updateUser, updateOffersEmail, updateOffersSms, updateOffersApp, updateNotifySms, updateNotifyApp, updateNotifyEmail, sendToDevice, driverRequests }
const stripe = new Stripe(functions.config().stripe.token);
const currency = 'EUR';

const createStripeCustomer = functions.auth.user().onCreate(async (user, context) => {
  const customer = await stripe.customers.create({ email: user.email });
  return firestore.collection('stripe_customers').doc(user.uid).set({ customer_id: customer.id });
});


// When a user deletes their account, clean up after them
const cleanupUser = functions.auth.user().onDelete(async (user) => {
  const snap = await firestore.collection('stripe_customers').doc(user.uid).get();
  const customerData = snap.data();
  await stripe.customers.del(customerData!.customer_id);
  return firestore.collection('stripe_customers').doc(user.uid).delete();
});

// When a user creates their account, assign them a type
const createUser = functions.firestore
  .document('users/{userId}')
  .onCreate(async (userSnapshot, context) => {
    const user = userSnapshot.data();
    if (user !== undefined) {
      if(user.type === undefined || user.type === null)
        await firestore.collection('users').doc(user.uid).update({ 'type': 'user' });
    }
  });

const addPaymentSource = functions.https.onCall(async (data, context) => {
  const token = data!.token;
  const customerData = (await firestore.collection('stripe_customers').doc(context.auth!.uid).get()).data();
  const customer = customerData!.customer_id;
  const response = await stripe.customers.createSource(customer, { source: token }, { api_key: functions.config().stripe.token });
  const mapResponse = (response as { [field: string]: any })
  const fingerPrint = mapResponse['card']['fingerprint']
  console.log("sourceId", fingerPrint)
  mapResponse.token = token
  await firestore.collection('stripe_customers').doc(context.auth!.uid)
    .collection("sources").doc(fingerPrint)
    .set(response);
  return { "documentId": fingerPrint, }
});

const sendToDeviceDriver = functions.firestore
  .document('users/{userId}/driver_orders/{orderId}')
  .onWrite(async (change, context) => {


    const order = change.after.data();
    if (order !== undefined) {
      console.log(order.driver);
      const querySnapshot = await firestore
        .collection('users')
        .doc(order.driver)
        .get();
      const user = querySnapshot.data();
      if (user !== undefined) {
        const tokens = user.fcmToken;
        console.log(tokens);
        if (user.type === 'driver') {
          if (order.state === 'ACCEPTED') {
            const payload: admin.messaging.MessagingPayload = {
              notification: {
                title: 'Ordine ha cambiato stato',
                body: 'Hai un ordine da consegnare il giorno ' + order.day + ' alle ore ' + order.endTime,
                icon: 'your-icon-url',
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
              }
            };
            return messaging.sendToDevice(tokens, payload);
          }
          else if (order.state === 'DELETED') {
            console.log(order.state);
            const payload: admin.messaging.MessagingPayload = {
              notification: {
                title: 'Ordine ha cambiato stato',
                body: 'Ordine in consegna il giorno ' + order.day + ' alle ore ' + order.endTime + ' è stato cancellato',
                icon: 'your-icon-url',
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
              }
            };
            return messaging.sendToDevice(tokens, payload);
          }
        }
      }
    }
    return 'ok';
  });

const sendToDevice = functions.firestore
  .document('users/{userId}/user_orders/{orderId}')
  .onWrite(async (change, context) => {


    const order = change.after.data();
    if (order !== undefined) {
      console.log(order.uid);
      const querySnapshot = await firestore
        .collection('users')
        .doc(order.uid)
        .get();
      const user = querySnapshot.data();
      if (user !== undefined) {
        const tokens = user.fcmToken;
        console.log(tokens);
        if (user.type === 'user') {
          const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: 'Ordine ha cambiato stato',
              body: 'Ordine del giorno ' + order.day + ' alle ore ' + order.endTime + stateString(order.state),
              icon: 'your-icon-url',
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
          };
          return messaging.sendToDevice(tokens, payload);
        }
      }
    }
    return 'ok';
  });

const driverRequests = functions.firestore
  .document('driver_requests/{userId}')
  .onWrite(async (change, context) => {
    const request = change.after.data();
    if (request !== undefined) {
      const querySnapshot = await firestore
        .collection('control_users')
        .doc('users')
        .get();
      const control = querySnapshot.data();
      if (control !== undefined) {
        for (const entry of control.users) {
          const query = await firestore
            .collection('users')
            .doc(entry)
            .get();
          const user = query.data()
          if (user !== undefined) {
            const tokens = user.fcmToken;
            console.log(tokens);
            if (user.type === 'control') {
              const payload: admin.messaging.MessagingPayload = {
                notification: {
                  title: 'Richiesta fattorino',
                  body: request.nominative + ' richiede di diventare un fattorino',
                  icon: 'your-icon-url',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
              messaging.sendToDevice(tokens, payload).catch((err) => console.log(err)).then(() => console.log('ok')).catch(() => 'Obligatory catch');
            }
          }
        }
      }
    }
    return 'ok';
  });

const supplierRequests = functions.firestore
  .document('supplier_requests/{userId}')
  .onWrite(async (change, context) => {
    const request = change.after.data();
    if (request !== undefined) {
      const querySnapshot = await firestore
        .collection('control_users')
        .doc('users')
        .get();
      const control = querySnapshot.data();
      if (control !== undefined) {
        for (const entry of control.users) {
          const query = await firestore
            .collection('users')
            .doc(entry)
            .get();
          const user = query.data()
          if (user !== undefined) {
            const tokens = user.fcmToken;
            console.log(tokens);
            if (user.type === 'control') {
              const payload: admin.messaging.MessagingPayload = {
                notification: {
                  title: 'Richiesta ristoratore',
                  body: request.ragioneSociale + ' richiede di diventare un ristoratore',
                  icon: 'your-icon-url',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
              messaging.sendToDevice(tokens, payload).catch((err) => console.log(err)).then(() => console.log('ok')).catch(() => 'Obligatory catch');
            }
          }
        }
      }
    }
    return 'ok';
  });

const productRequests = functions.firestore
  .document('product_requests/{userId}')
  .onWrite(async (change, context) => {
    const request = change.after.data();
    if (request !== undefined) {
      const querySnapshot = await firestore
        .collection('control_users')
        .doc('users')
        .get();
      const control = querySnapshot.data();
      if (control !== undefined) {
        for (const entry of control.users) {
          const query = await firestore
            .collection('users')
            .doc(entry)
            .get();
          const user = query.data()
          if (user !== undefined) {
            const tokens = user.fcmToken;
            console.log(tokens);
            if (user.type === 'control') {
              const payload: admin.messaging.MessagingPayload = {
                notification: {
                  title: 'Richiesta prodotto',
                  body: request.supplierId + ' richiede di aggiungere un prodotto',
                  icon: 'your-icon-url',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
              messaging.sendToDevice(tokens, payload).catch((err) => console.log(err)).then(() => console.log('ok')).catch(() => 'Obligatory catch');
            }
          }
        }
      }
    }
    return 'ok';
  });

const sendToDeviceSupplier = functions.firestore
  .document('suppliers/{supplierId}/supplier_orders/{orderId}')
  .onWrite(async (change, context) => {


    const order = change.after.data();
    if (order !== undefined) {
      console.log(order.supplierId);
      const querySnapshot = await firestore
        .collection('suppliers')
        .doc(order.supplierId)
        .get();
      const supplier = querySnapshot.data();
      if (supplier !== undefined) {
        const query = await firestore
          .collection('users')
          .doc(supplier.uid)
          .get();
        const user = query.data();
        if (user !== undefined) {
          const tokens = user.fcmToken;
          console.log(tokens);
          if (user.type === 'supplier') {
            if (order.state === 'ACCEPTED') {
              const payload: admin.messaging.MessagingPayload = {
                notification: {
                  title: 'Ordine ha cambiato stato',
                  body: 'Hai un nuovo ordine per il giorno ' + order.day + ' alle ore ' + order.endTime,
                  icon: 'your-icon-url',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
              return messaging.sendToDevice(tokens, payload);
            }
            else if (order.state === 'DELETED') {
              const payload: admin.messaging.MessagingPayload = {
                notification: {
                  title: 'Ordine ha cambiato stato',
                  body: 'Ordine in consegna il giorno ' + order.day + ' alle ore ' + order.endTime + ' è stato cancellato',
                  icon: 'your-icon-url',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
              return messaging.sendToDevice(tokens, payload);
            }
            else if (order.state === 'DELIVERED') {
              const payload: admin.messaging.MessagingPayload = {
                notification: {
                  title: 'Ordine ha cambiato stato',
                  body: 'Ordine in consegna il giorno ' + order.day + ' alle ore ' + order.endTime + ' è stato consegnato',
                  icon: 'your-icon-url',
                  click_action: 'FLUTTER_NOTIFICATION_CLICK'
                }
              };
              return messaging.sendToDevice(tokens, payload);
            }
          }
        }
      }
    }
    return 'ok';
  });

/*
  const sendToDeviceDriver = functions.firestore
  .document('suppliers/{supplierId}/supplier_orders/{orderId}')
  .onWrite(async (change,context) => {
    const order = change.after.data();
    if(order!== undefined){
      console.log(order.driver);
      const querySnapshot = await fs
      .collection('users')
      .doc(order.driver)
      .get();
      const user=querySnapshot.data();
      if(user.type==='driver'){
        if(order.state==='ACCEPTED'){
          const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: 'Ordine ha cambiato stato',
              body: 'Hai un ordine da consegnare il giorno '+order.day+' alle ore '+order.endTime,
              icon: 'your-icon-url',
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
              }
            };
            return sms.sendToDevice(tokens, payload);
          }
        }
        else if(order.state==='DELETED'){
          const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: 'Ordine ha cambiato stato',
              body: 'Ordine in consegna il giorno '+order.day+' alle ore '+order.endTime+' è stato cancellato',
              icon: 'your-icon-url',
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
              }
            };
            return sms.sendToDevice(tokens, payload);
          }
      }
    }
    return 'ok';
  });

const sendToDeviceSupplier = functions.firestore
  .document('suppliers/{userId}/supplier_orders/{orderId}')
  .onWrite(async (change,context) => {

    
    const order = change.after.data();
    if(order!== undefined){
      console.log(order.rid);
      const querySnapshot = await fs
      .collection('users')
      .doc(order.rid)
      .get();
      const user=querySnapshot.data();
      if( user!== undefined) {
        const tokens = user.fcmToken;
        console.log(tokens);
        if(user.type==='supplier'){
          if(order.state==='PENDING'){
            const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: 'Ordine ha cambiato stato',
              body: 'Hai un nuovo ordine per il giorno '+order.day+' alle ore '+order.endTime,
              icon: 'your-icon-url',
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
              }
            };
            return sms.sendToDevice(tokens, payload);
          }
          else if(order.state==='DELETED'){
            const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: 'Ordine ha cambiato stato',
              body: 'Ordine in consegna il giorno '+order.day+' alle ore '+order.endTime+' è stato cancellato',
              icon: 'your-icon-url',
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
              }
            };
            return sms.sendToDevice(tokens, payload);
          }
          else if(order.state==='DELIVERED'){
            const payload: admin.messaging.MessagingPayload = {
            notification: {
              title: 'Ordine ha cambiato stato',
              body: 'Ordine in consegna il giorno '+order.day+' alle ore '+order.endTime+' è stato consegnato',
              icon: 'your-icon-url',
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
              }
            };
            return sms.sendToDevice(tokens, payload);
          }
        }
    }
    return 'ok';
  });
  */

const updateState = functions.https.onCall(async (data, context) => {
  const state = data.state;
  const rid = data.rid;
  const oid = data.oid;
  const uid = data.uid;
  const did = data.did;
  const timeS = data.timeS;
  if (state === 'ACCEPTED') await firestore.collection('suppliers').doc(rid).collection('supplier_orders').doc(oid).update({ 'state': state, 'timeS': timeS, 'isPaid': true });
  else await firestore.collection('suppliers').doc(rid).collection('supplier_orders').doc(oid).update({ 'state': state, 'timeS': timeS });
  await firestore.collection('users').doc(did).collection('driver_orders').doc(oid).update({ 'state': state, 'timeS': timeS });
  await firestore.collection('users').doc(uid).collection('user_orders').doc(oid).update({ 'state': state, 'timeS': timeS });
  if (state === 'DENIED') {
    const day = data.day;
    const startTime = data.startTime;
    const free = data.free;
    const occupied = data.occupied;
    const isEmpty = data.isEmpty;
    await firestore.collection('days').doc(day).collection('times').doc(startTime).update({ 'free': free, 'occupied': occupied, 'isEmpty': isEmpty });
  }
  return { "documentId": "id", }
});

const updateUser = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  const email = data.email;
  const nominative = data.nominative;
  await firestore.collection('users').doc(uid).update({ 'email': email, 'nominative': nominative });
  return { "documentId": "id", }
});

const updateNotifyEmail = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  const notifyEmail = data.notifyEmail;
  await firestore.collection('users').doc(uid).update({ 'notifyEmail': notifyEmail });
  return { "documentId": "id", }
});

const updateNotifySms = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  const notifySms = data.notifySms;
  await firestore.collection('users').doc(uid).update({ 'notifySms': notifySms });
  return { "documentId": "id", }
});

const updateNotifyApp = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  const notifyApp = data.notifyApp;
  await firestore.collection('users').doc(uid).update({ 'notifyApp': notifyApp });
  return { "documentId": "id", }
});

const updateOffersEmail = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  const offersEmail = data.offersEmail;
  await firestore.collection('users').doc(uid).update({ 'offersEmail': offersEmail });
  return { "documentId": "id", }
});

const updateOffersSms = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  const offersSms = data.offersSms;
  await firestore.collection('users').doc(uid).update({ 'offersSms': offersSms });
  return { "documentId": "id", }
});

const updateOffersApp = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  const offersApp = data.offersApp;
  await firestore.collection('users').doc(uid).update({ 'offersApp': offersApp });
  return { "documentId": "id", }
});

const setShift = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  const users = data.free;
  const startTime = data.startTime;
  const endTime = data.endTime;
  const day = data.day;
  const month = data.month;
  const year = data.year;
  const isEmpty = data.isEmpty;
  console.log(users);
  console.log(isEmpty);
  await firestore.collection('days').doc(day).collection('times').doc(startTime).update({ 'free': users, 'isEmpty': isEmpty });
  await firestore.collection('users').doc(uid).collection('turns').doc(day + '§' + startTime).create({ 'startTime': startTime, 'endTime': endTime, 'day': day, 'month': month, 'year': year });
  return { "documentId": "id", }
});


const createStripeCharge = functions.https.onCall(async (data, context) => {
  try {
    const foodIds = data.foodIds;
    const drinkIds = data.drinkIds;
    const supplierId = data.supplierId;
    const uid = data.uid;
    const customerRef = firestore.collection('stripe_customers').doc(uid)
    const customerData = (await customerRef.get()).data();
    const customer = customerData!.customer_id;
    console.log(customer);
    const idempotencyKey = data.oid;
    console.log(uid);
    const amount = ((await calculatePrice(foodIds, 'foods', supplierId)) + (await calculatePrice(drinkIds, 'drinks', supplierId))) * 100;
    //const idempotencyKey = context.params.id;
    const charge: Stripe.charges.IChargeCreationOptions = { amount, currency, customer };
    console.log(data.fingerprint);
    charge.source = data.fingerprint;
    const response = await stripe.charges.create(charge, { idempotency_key: idempotencyKey });
    return customerRef.collection('charges').add(response);
    console.log(amount);
    return
  } catch (error) {
    console.log(error);
    return
    //await snap.ref.set({error: userFacingMessage(error)}, { merge: true });
    //return reportError(error, {user: context.params.userId});
  }
});

/*//Creazione pagamento
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
*/

async function calculatePrice(products: string[], collectionId: string, supplierId: string): Promise<number> {
  let price = 0
  for (const entry of products) {
    const product = (await (firestore.collection('suppliers').doc(supplierId).collection(collectionId).doc(entry)).get()).data()
    //console.log(product.price)
    price += product ? parseInt(product.price, 10) : 0
  }
  return price
}

function stateString(state: string): string {
  if (state === 'ACCEPTED') return ' è in consegna'
  if (state === 'PENDING') return ' in fase di accettazione'
  if (state === 'DELETED') return ' è stato cancellato'
  if (state === 'DELIVERED') return ' è stato consegnato. Lascia una recensione sul ristorante ed il fattorino.'
  return ' non è stato approvato dal ristorante'

}


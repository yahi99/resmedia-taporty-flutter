import { addPaymentSource, createStripeCharge, createStripeCustomer, sendToDevice, sendToDeviceDriver, sendToDeviceSupplier, driverRequests, supplierRequests, productRequests, cleanupUser, updateState, setShift, updateUser, updateOffersEmail, updateOffersSms, updateOffersApp, updateNotifySms, updateNotifyApp, updateNotifyEmail, createUser } from './lib/payment_function';
import { onOrderCreate, onOrderUpdate, onOrderCancellationRefund } from './lib/orders_function';
import { onSupplierRequestChanged, onDriverRequestChanged } from './lib/requests';
import { onDriverReviewCreated, onSupplierReviewCreated } from './lib/reviews_function';

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript
// firebase deploy
// firebase deploy --only functions
// npm install @google-cloud/firestore

exports.sendToDevice = sendToDevice;
exports.sendToDeviceSupplier = sendToDeviceSupplier;
exports.sendToDeviceDriver = sendToDeviceDriver;
exports.driverRequests = driverRequests;
exports.supplierRequests = supplierRequests;
exports.productRequests = productRequests;
exports.updateState = updateState;
exports.createStripeCustomer = createStripeCustomer;
exports.cleanupUser = cleanupUser
// Aggiungere carta
exports.addPaymentSource = addPaymentSource;
exports.createStripeCharge = createStripeCharge;
exports.setShift = setShift;
exports.updateUser = updateUser;
exports.updateNotifyEmail = updateNotifyEmail;
exports.updateNotifySms = updateNotifySms;
exports.updateNotifyApp = updateNotifyApp;
exports.updateOffersEmail = updateOffersEmail;
exports.updateOffersSms = updateOffersSms;
exports.updateOffersApp = updateOffersApp;
exports.onOrderCreate = onOrderCreate;
exports.onOrderUpdate = onOrderUpdate;
exports.onOrderCancellationRefund = onOrderCancellationRefund;
exports.onSupplierRequestChanged = onSupplierRequestChanged;
exports.onDriverRequestChanged = onDriverRequestChanged;
exports.createUser = createUser;
exports.onDriverReviewCreated = onDriverReviewCreated;
exports.onSupplierReviewCreated = onSupplierReviewCreated;

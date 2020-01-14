import * as admin from 'firebase-admin'

// tslint:disable-next-line: no-use-before-declare
export { app, firestore, messaging, auth }

const app = admin.initializeApp()
const auth = admin.auth();
const firestore = admin.firestore(app)
const messaging = admin.messaging(app)
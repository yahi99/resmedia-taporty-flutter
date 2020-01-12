import * as admin from 'firebase-admin'

// tslint:disable-next-line: no-use-before-declare
export { app, firebase, messaging }

const app = admin.initializeApp()
const firebase = admin.firestore(app)
const messaging = admin.messaging(app)
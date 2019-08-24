import * as admin from 'firebase-admin'

// tslint:disable-next-line: no-use-before-declare
export { app, fs, sms }

const app = admin.initializeApp()
const fs = admin.firestore(app)
const sms = admin.messaging(app)
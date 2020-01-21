import * as functions from 'firebase-functions';
import { firestore, auth } from './firebase';
import RequestStates from './models/request_states';
import { sgMail, SUPPLIER_REQUEST_REFUSED_TEMPLATE, SUPPLIER_REQUEST_ACCEPTED_TEMPLATE, DRIVER_REQUEST_ACCEPTED_TEMPLATE, DRIVER_REQUEST_REFUSED_TEMPLATE } from './sendgrid';

const onSupplierRequestChanged = functions.firestore.document('supplier_requests/{requestId}').onUpdate(async (change, context) => {
    let newRequest = change.after.data();
    let prevRequest = change.before.data();
    if (newRequest === undefined || prevRequest === undefined)
        return;

    if (prevRequest.state !== RequestStates.PENDING)
        return;

    if (newRequest.state === RequestStates.ACCEPTED) {
        var supplierRef = firestore.collection('suppliers').doc();
        await supplierRef.set({
            name: newRequest.supplierName,
            partitaIVA: newRequest.partitaIVA,
            description: newRequest.description,
            imageUrl: newRequest.imageUrl,
            phoneNumber: newRequest.phoneNumber,
            coordinates: newRequest.coordinates,
            address: newRequest.address,
            deliveryRadius: newRequest.deliveryRadius,
            weekdayTimetable: {
                1: {
                    open: true,
                    timeslotCount: 2,
                    timeslots: [
                        { start: "11:30", end: "15:00" },
                        { start: "19:00", end: "23:30" }
                    ]
                },
                2: {
                    open: true,
                    timeslotCount: 2,
                    timeslots: [
                        { start: "11:30", end: "15:00" },
                        { start: "19:00", end: "23:30" }
                    ]
                },
                3: {
                    open: true,
                    timeslotCount: 2,
                    timeslots: [
                        { start: "11:30", end: "15:00" },
                        { start: "19:00", end: "23:30" }
                    ]
                },
                4: {
                    open: true,
                    timeslotCount: 2,
                    timeslots: [
                        { start: "11:30", end: "15:00" },
                        { start: "19:00", end: "23:30" }
                    ]
                },
                5: {
                    open: true,
                    timeslotCount: 2,
                    timeslots: [
                        { start: "11:30", end: "15:00" },
                        { start: "19:00", end: "23:30" }
                    ]
                },
                6: {
                    open: true,
                    timeslotCount: 2,
                    timeslots: [
                        { start: "11:30", end: "15:00" },
                        { start: "19:00", end: "23:30" }
                    ]
                },
                7: {
                    open: false,
                },
            },
            holidays: [
                {
                    name: "Natale",
                    start: "24-12",
                    end: "28-12",
                },
                {
                    name: "Capodanno",
                    start: "31-12",
                    end: "02-01",
                }
            ],
            reference: supplierRef,
        });

        await firestore.collection('users').doc(newRequest.uid).set({
            nominative: newRequest.name,
            email: newRequest.email,
            type: 'supplier-admin',
        });

        await auth.setCustomUserClaims(newRequest.uid, { supplierAdmin: true, supplierId: supplierRef.id });
        
        await sgMail.send({
            to: newRequest.email,
            from: 'noreply@taporty-779ff.firebaseapp.com',
            templateId: SUPPLIER_REQUEST_ACCEPTED_TEMPLATE,
            dynamicTemplateData: {
                name: newRequest.name
            }
        });
    }
    else if (newRequest.state === RequestStates.REFUSED) {
        await auth.deleteUser(newRequest.uid);
        await sgMail.send({
            to: newRequest.email,
            from: 'noreply@taporty-779ff.firebaseapp.com',
            templateId: SUPPLIER_REQUEST_REFUSED_TEMPLATE,
            dynamicTemplateData: {
                name: newRequest.name
            }
        });
    }
});

const onDriverRequestChanged = functions.firestore.document('driver_requests/{requestId}').onUpdate(async (change, context) => {
    let newRequest = change.after.data();
    let prevRequest = change.before.data();
    if (newRequest === undefined || prevRequest === undefined)
        return;

    if (prevRequest.state !== RequestStates.PENDING)
        return;

    if (newRequest.state === RequestStates.ACCEPTED) {
        await firestore.collection('users').doc(newRequest.uid).set({
            nominative: newRequest.name,
            email: newRequest.email,
            phoneNumber: newRequest.phoneNumber,
            imageUrl: newRequest.imageUrl,
            type: 'driver',
            coordinates: newRequest.coordinates,
            address: newRequest.address,
            deliveryRadius: newRequest.deliveryRadius,
        });

        await auth.setCustomUserClaims(newRequest.uid, { driver: true });
        
        await sgMail.send({
            to: newRequest.email,
            from: 'noreply@taporty-779ff.firebaseapp.com',
            templateId: DRIVER_REQUEST_ACCEPTED_TEMPLATE,
            dynamicTemplateData: {
                name: newRequest.name
            }
        });
    }
    else if (newRequest.state === RequestStates.REFUSED) {
        await auth.deleteUser(newRequest.uid);
        await sgMail.send({
            to: newRequest.email,
            from: 'noreply@taporty-779ff.firebaseapp.com',
            templateId: DRIVER_REQUEST_REFUSED_TEMPLATE,
            dynamicTemplateData: {
                name: newRequest.name
            }
        });
    }
});

export { onSupplierRequestChanged, onDriverRequestChanged }
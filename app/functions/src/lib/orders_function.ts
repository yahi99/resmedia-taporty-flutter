import * as functions from 'firebase-functions';
import * as moment from 'moment';
import { firestore } from './firebase';
import OrderStates from './models/order_states';
import { Timestamp } from '@google-cloud/firestore';

const onOrderCreate = functions.firestore.document('orders/{orderId}').onCreate(async (orderSnapshot, context) => {
    let order = orderSnapshot.data();
    if (order == undefined)
        return;
    if (order.oldOrderId != undefined && order.oldOrderId != null) {
        await orderSnapshot.ref.collection("events").add({
            description: "L'ordine è stato creato in seguito alla modifica di un altro ordine.",
            oldOrderId: order.oldOrderId,
            timestamp: order.creationTimestamp,
        });
    }
    else {
        await orderSnapshot.ref.collection("events").add({
            description: "L'ordine è stato creato.",
            timestamp: order.creationTimestamp,
        });

        let notificationRef = firestore.collection("restaurants").doc(order.restaurantId).collection("notifications").doc();
        await notificationRef.set({
            oldState: null,
            newState: OrderStates.NEW,
            orderId: orderSnapshot.ref.id,
            reference: notificationRef,
            timestamp: order.creationTimestamp,
            visualized: false,
        });
    }
});

const onOrderUpdate = functions.firestore.document('orders/{orderId}').onUpdate(async (change, context) => {
    let orderSnapshot = change.after;
    let oldOrder = change.before.data();
    let newOrder = change.after.data();
    if (oldOrder === undefined || newOrder === undefined)
        return;

    if (oldOrder.state === newOrder.state)
        return;

    let notificationRef = firestore.collection("restaurants").doc(newOrder.restaurantId).collection("notifications").doc();

    if (newOrder.state === OrderStates.ACCEPTED) {
        if (oldOrder.state === OrderStates.MODIFIED) {
            await orderSnapshot.ref.collection("events").add({
                description: "La modifica è stata rifiutata.",
                timestamp: Timestamp.fromMillis(moment().valueOf()),
            });
        }
        if (oldOrder.state === OrderStates.NEW) {
            await orderSnapshot.ref.collection("events").add({
                description: "L'ordine è stato accettato.",
                timestamp: newOrder.acceptanceTimestamp,
            });
        }
    }
    else if (newOrder.state === OrderStates.READY) {
        if (oldOrder.state === OrderStates.MODIFIED) {
            await orderSnapshot.ref.collection("events").add({
                description: "La modifica è stata rifiutata.",
                timestamp: Timestamp.fromMillis(moment().valueOf()),
            });
        }
        if (oldOrder.state === OrderStates.ACCEPTED) {
            await orderSnapshot.ref.collection("events").add({
                description: "L'ordine è stato preparato.",
                timestamp: newOrder.readyTimestamp,
            });
        }
    }
    else if (newOrder.state === OrderStates.PICKED_UP) {
        await orderSnapshot.ref.collection("events").add({
            description: "L'ordine è stato preso in carico dal fattorino.",
            timestamp: newOrder.pickupTimestamp,
        });
    }
    else if (newOrder.state === OrderStates.DELIVERED) {
        await orderSnapshot.ref.collection("events").add({
            description: "L'ordine è stato consegnato al cliente.",
            timestamp: newOrder.deliveryTimestamp,
        });

        await notificationRef.set({
            oldState: OrderStates.PICKED_UP,
            newState: OrderStates.DELIVERED,
            orderId: orderSnapshot.ref.id,
            reference: notificationRef,
            timestamp: newOrder.deliveryTimestamp,
            visualized: false,
        });
    }
    else if (newOrder.state == OrderStates.CANCELLED) {
        await orderSnapshot.ref.collection("events").add({
            description: "L'ordine è stato annullato dal cliente.",
            timestamp: newOrder.cancellationTimestamp,
        });

        await notificationRef.set({
            oldState: oldOrder.state,
            newState: OrderStates.CANCELLED,
            orderId: orderSnapshot.ref.id,
            reference: notificationRef,
            timestamp: newOrder.cancellationTimestamp,
            visualized: false,
        });
    }
    else if (newOrder.state === OrderStates.REFUSED) {
        await orderSnapshot.ref.collection("events").add({
            description: "L'ordine è stato rifiutato.",
            timestamp: newOrder.refusalTimestamp,
        });
    }
    else if (newOrder.state === OrderStates.MODIFIED) {
        await orderSnapshot.ref.collection("events").add({
            description: "E' pervenuta una richiesta di modifica da parte del cliente.",
            timestamp: newOrder.modificationTimestamp,
        });

        await notificationRef.set({
            oldState: oldOrder.state,
            newState: OrderStates.MODIFIED,
            orderId: orderSnapshot.ref.id,
            reference: notificationRef,
            timestamp: newOrder.modificationTimestamp,
            visualized: false,
        });
    }
    else if (newOrder.state === OrderStates.ARCHIVED) {
        if (oldOrder.state === OrderStates.MODIFIED) {
            await orderSnapshot.ref.collection("events").add({
                description: "La richiesta di modifica è stata accettata e l'ordine è stato archiviato.",
                newOrderId: newOrder.newOrderId,
                timestamp: newOrder.archiviationTimestamp,
            });
        }
        else if (oldOrder.state === OrderStates.NEW) {
            await orderSnapshot.ref.collection("events").add({
                description: "L'ordine è stato archiviato in seguito alla modifica del cliente.",
                newOrderId: newOrder.newOrderId,
                timestamp: newOrder.archiviationTimestamp,
            });
        }
    }
});

const onOrderCancellationRefund = functions.firestore.document('orders/{orderId}').onUpdate(async (change, context) => {
    let orderSnapshot = change.after;
    let oldOrder = change.before.data();
    let newOrder = change.after.data();
    if (oldOrder === undefined || newOrder === undefined)
        return;

    if (newOrder.state !== OrderStates.CANCELLED)
        return;

    // If the order hadn't been accepted, refund the customer in any case 
    if (oldOrder.state === OrderStates.NEW) {
        newOrder.refund = true;
    }
    else {
        // If the order had already been accepted, refund the customer only if the restaurant has decided so
        if (oldOrder.replied === newOrder.replied || newOrder.replied === false)
            return;
    }

    if (newOrder.refund === true) {
        await orderSnapshot.ref.collection("events").add({
            description: "L'ordine è stato rimborsato.",
            timestamp: newOrder.archiviationTimestamp,
        });
    }
    else {
        await orderSnapshot.ref.collection("events").add({
            description: "L'ordine non è stato rimborsato.",
            timestamp: newOrder.archiviationTimestamp,
        });
    }
});

export { onOrderCreate, onOrderUpdate, onOrderCancellationRefund }
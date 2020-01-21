import * as functions from 'firebase-functions';
import { firestore } from './firebase';

const onSupplierReviewCreated = functions.firestore
    .document('/suppliers/{supplierId}/reviews/{reviewId}')
    .onCreate(async (snapshot, context) => {
        const documentReference = firestore.collection("suppliers").doc(context.params.supplierId);

        return firestore.runTransaction((tx) => {
            return tx.get(documentReference).then((supplierSnapshot) => {
                let oldReviewCount = supplierSnapshot.get("numberOfReviews") === undefined ? 0 : supplierSnapshot.get("numberOfReviews");
                let reviewCount = oldReviewCount + 1;
                let oldRating = supplierSnapshot.get("averageReviews") === undefined ? 0 : supplierSnapshot.get("averageReviews");
                let rating = (oldRating *
                    oldReviewCount +
                    snapshot.get("rating")) /
                    reviewCount;

                return tx.update(supplierSnapshot.ref, {
                    'numberOfReviews': reviewCount,
                    'averageReviews': rating
                });
            });
        });
    });

const onDriverReviewCreated = functions.firestore
    .document('/users/{driverId}/reviews/{reviewId}')
    .onCreate(async (snapshot, context) => {
        const documentReference = firestore.collection("users").doc(context.params.driverId);

        return firestore.runTransaction((tx) => {
            return tx.get(documentReference).then((driverSnapshot) => {
                let oldReviewCount = driverSnapshot.get("numberOfReviews") === undefined ? 0 : driverSnapshot.get("numberOfReviews");
                let reviewCount = oldReviewCount + 1;
                let oldRating = driverSnapshot.get("averageReviews") === undefined ? 0 : driverSnapshot.get("averageReviews");
                let rating = (oldRating *
                    oldReviewCount +
                    snapshot.get("rating")) /
                    reviewCount;

                return tx.update(driverSnapshot.ref, {
                    'numberOfReviews': reviewCount,
                    'averageReviews': rating
                });
            });
        });
    });

export { onDriverReviewCreated, onSupplierReviewCreated };
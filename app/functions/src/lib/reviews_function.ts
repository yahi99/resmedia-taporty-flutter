import * as functions from 'firebase-functions';
import { firestore } from './firebase';

const onRestaurantReviewCreated = functions.firestore
    .document('/restaurants/{restaurantId}/reviews/{reviewId}')
    .onCreate(async (snapshot, context) => {
        const documentReference = firestore.collection("restaurants").doc(context.params.restaurantId);

        return firestore.runTransaction((tx) => {
            return tx.get(documentReference).then((restaurantSnapshot) => {
                let oldReviewCount = restaurantSnapshot.get("numberOfReviews") === undefined ? 0 : restaurantSnapshot.get("numberOfReviews");
                let reviewCount = oldReviewCount + 1;
                let oldRating = restaurantSnapshot.get("averageReviews") === undefined ? 0 : restaurantSnapshot.get("averageReviews");
                let rating = (oldRating *
                    oldReviewCount +
                    snapshot.get("rating")) /
                    reviewCount;

                return tx.update(restaurantSnapshot.ref, {
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

export { onDriverReviewCreated, onRestaurantReviewCreated };
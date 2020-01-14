import * as sgMail from '@sendgrid/mail';
import * as functions from 'firebase-functions';

const API_KEY = functions.config().sendgrid.key;
const RESTAURANT_REQUEST_ACCEPTED_TEMPLATE = functions.config().sendgrid.restaurant_request_accepted;
const RESTAURANT_REQUEST_REFUSED_TEMPLATE = functions.config().sendgrid.restaurant_request_refused;
const DRIVER_REQUEST_ACCEPTED_TEMPLATE = functions.config().sendgrid.driver_request_accepted;
const DRIVER_REQUEST_REFUSED_TEMPLATE = functions.config().sendgrid.driver_request_refused;
sgMail.setApiKey(API_KEY);

export { sgMail, RESTAURANT_REQUEST_ACCEPTED_TEMPLATE, RESTAURANT_REQUEST_REFUSED_TEMPLATE, DRIVER_REQUEST_ACCEPTED_TEMPLATE, DRIVER_REQUEST_REFUSED_TEMPLATE};
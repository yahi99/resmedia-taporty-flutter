import * as sgMail from '@sendgrid/mail';
import * as functions from 'firebase-functions';

const API_KEY = functions.config().sendgrid.key;
const SUPPLIER_REQUEST_ACCEPTED_TEMPLATE = functions.config().sendgrid.supplier_request_accepted;
const SUPPLIER_REQUEST_REFUSED_TEMPLATE = functions.config().sendgrid.supplier_request_refused;
const DRIVER_REQUEST_ACCEPTED_TEMPLATE = functions.config().sendgrid.driver_request_accepted;
const DRIVER_REQUEST_REFUSED_TEMPLATE = functions.config().sendgrid.driver_request_refused;
sgMail.setApiKey(API_KEY);

export { sgMail, SUPPLIER_REQUEST_ACCEPTED_TEMPLATE, SUPPLIER_REQUEST_REFUSED_TEMPLATE, DRIVER_REQUEST_ACCEPTED_TEMPLATE, DRIVER_REQUEST_REFUSED_TEMPLATE};
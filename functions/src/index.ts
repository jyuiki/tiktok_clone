/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as functions from "firebase-functions"
import * as admin from "firebase-admin";

admin.initializeApp();

export const onVideoCreated = functions.firestore.document("/videos/{videoId}").onCreate(async(snapshot, context)=> {
    await snapshot.ref.update({hello : "from functions"});
});

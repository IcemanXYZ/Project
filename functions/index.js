const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.assignUserRole = functions.auth.user().onCreate((user) => {
  // Define the role based on the email domain
  const email = user.email || "";
  let role = "external";

  if (email.endsWith("@students.wua.ac.zw")) {
    role = "student";
  } else if (email.endsWith("@wua.ac.zw")) {
    role = "faculty";
  }

  // Set custom user claims
  return admin.auth().setCustomUserClaims(user.uid, {role: role})
      .then(() => {
        // Update the user document in Firestore
        return admin.firestore().collection("users").doc(user.uid).set({
          email: email,
          role: role,
        }, {merge: true});
      })
      .catch((error) => {
        console.error("Error setting custom claims", error);
      });
});

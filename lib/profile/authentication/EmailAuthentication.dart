import 'package:Eresse/profile/DI/AuthenticationDI.dart';
import 'package:Eresse/profile/authentication/Interface/AuthenticationInterface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EmailAuthentication {

  User? firebaseUser = FirebaseAuth.instance.currentUser;

  final AuthenticationDI _authenticationDI = AuthenticationDI();

  void start(AuthenticationInterface authenticationInterface) async {
    debugPrint("Authentication: Start");

    final GoogleSignIn signIn = GoogleSignIn.instance;

    await signIn.disconnect();
    await signIn.signOut();

    await signIn.initialize();

    signIn.authenticationEvents.listen((authEvent) async {

        GoogleSignInAccount? googleSignInAccount = switch (authEvent) {
          GoogleSignInAuthenticationEventSignIn() => authEvent.user,
          GoogleSignInAuthenticationEventSignOut() => null,
        };

        if (googleSignInAccount != null) {

          final GoogleSignInAuthentication googleAuthentication = googleSignInAccount.authentication;

          final googleCredential = GoogleAuthProvider.credential(
            accessToken: googleAuthentication.idToken,
            idToken: googleAuthentication.idToken,
          );

          FirebaseAuth.instance.signInWithCredential(googleCredential).then((userCredential) {

            authenticationInterface.authenticated(userCredential);

            String? emailAddress = userCredential.user?.email;

            if (emailAddress != null) {

              FirebaseFirestore.instance.doc(_authenticationDI.profileEndpoint.profileDocument(emailAddress))
                .set({
                  emailAddress: emailAddress.toString()
                });

            }

          });

        }

    }).onError((error) => {
      debugPrint(error)
    });

    final googleSignInAccount = await signIn.attemptLightweightAuthentication();

  }

}
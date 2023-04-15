import 'package:chet/Screen/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoginScreen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            FirebaseAuth auth = FirebaseAuth.instance;
            User? user;

            final GoogleSignIn googleSignIn = GoogleSignIn();

            final GoogleSignInAccount? googleSignInAccount =
                await googleSignIn.signIn();

            if (googleSignInAccount != null) {
              final GoogleSignInAuthentication googleSignInAuthentication =
                  await googleSignInAccount.authentication;

              final AuthCredential credential = GoogleAuthProvider.credential(
                accessToken: googleSignInAuthentication.accessToken,
                idToken: googleSignInAuthentication.idToken,
              );

              UserCredential userCredential =
                  await auth.signInWithCredential(credential);

              user = userCredential.user;

              var name =user!.displayName.toString();
              var email=user!.email.toString();
              var googleid=user!.uid.toString();
              var photo=user!.photoURL.toString();
              
              await FirebaseFirestore.instance.collection("Chat")
                  .where("email",isEqualTo: email).get().then((documents)async{
                    if(documents.size<=0)
                      {
                        await FirebaseFirestore.instance.collection("Chat").add({
                          "displayName":name,
                          "email":email,
                          "uid":googleid,
                          "photoURL":photo,

                        }).then((documents) async{
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          prefs.setString("islogin", "yes");
                          prefs.setString("senderid",documents.id.toString());
                          prefs.setString("Name",name.toString());
                          prefs.setString("email",email.toString());
                          prefs.setString("GoogleId",googleid.toString());
                          prefs.setString("Photo",photo.toString());
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HomePage()));
                        });
                      }
                    else
                      {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        prefs.setString("islogin", "yes");
                        prefs.setString("Name",name.toString());
                        prefs.setString("email",email.toString());
                        prefs.setString("senderid",documents.docs.first.id.toString());
                        prefs.setString("GoogleId",googleid.toString());
                        prefs.setString("Photo",photo.toString());
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePage()));

                      }
              });










            }
          },
          child: Text("Login"),
        ),
      ),
    );
  }
}

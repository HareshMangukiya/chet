import 'package:chet/Screen/ChatPage.dart';
import 'package:chet/Screen/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var name="";
  var email="";
  var photo="";
  var googleid="";
  getdata()async{
    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    setState(() {
      name= prefs.getString("Name").toString();
      email= prefs.getString("email").toString();
      photo= prefs.getString("Photo").toString();
      googleid= prefs.getString("GoogleId").toString();
    });

}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      drawer: Drawer(
        child: Column(

          children: [
            SizedBox(height: 50.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Image.network(photo),
                ),

              ],
            ),
            SizedBox(height: 20.0,),
            Text("Email="+email),

            Text("Name="+name),
            SizedBox(height: 25.0,),
            ElevatedButton(onPressed: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();

              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.signOut();

              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }, child:Text("LogOut")),

          ],
        ),
      ),
      body:(email!="")? StreamBuilder(
        stream:FirebaseFirestore.instance.collection("Chat").where("email",isNotEqualTo:email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData)
            {
              if(snapshot.data!.size <=0)
                {
                  return Center(
                    child: Text("No Dota"),
                  );

                }
              else
                {
                  return ListView(
                    children:
                      snapshot.data!.docs.map((document){
                        return ListTile(
                          onTap: ()async{
                            var id=document.id.toString();
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ChatPage(
                                  name:document["displayName"],
                                  email:document["email"],
                                  photo: document["photoURL"].toString(),
                                  receiverid: id,
                                )));

                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(document["photoURL"].toString()),
                          ),
                          title: Text(document["displayName"]),
                          subtitle:Text(document["email"]),


                        );
                      }).toList(),

                  );
                }

            }
          else
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

        },
      ):SizedBox(),
    );
  }
}

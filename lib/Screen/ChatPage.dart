import 'dart:io';

import 'package:chet/Screen/PhotoScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  var name="";
  var photo="";
  var email="";
  var receiverid="";
  ChatPage({required this.name,required this.photo,required this.email,required this.receiverid,});


  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var senderid="";
  getdata()async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      senderid=prefs.getString("senderid").toString();
    });
  }


  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  TextEditingController _msg =TextEditingController();
  ImagePicker _picker = ImagePicker();
  File? selectedfile;

  var photo="";

  bool isloading=false;



  bool _showemoji=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          leadingWidth: 70,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30,),
                  child: Image.network(widget.photo,width: 45,),
                ),
              ],
            ),
          ),
          title: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                   widget.email,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),

                ],
              ),
            ),
          ),
          actions: [
            IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
            IconButton(icon: Icon(Icons.call), onPressed: () {}),
            PopupMenuButton(
              padding: EdgeInsets.all(0),
              onSelected: (value) {

              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: Text("View Contact"),
                    value: 0,
                  ),
                  PopupMenuItem(
                    onTap: (){


                    },
                    child: Text("Media, links, and docs"),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text("Whatsapp Web"),
                    value:2,
                  ),
                  PopupMenuItem(
                    child: Text("Search"),
                    value: 3,
                  ),
                  PopupMenuItem(
                    child: Text("Mute Notification"),
                    value: "Mute Notification",
                  ),
                  PopupMenuItem(
                    child: Text("Wallpaper"),
                    value: "Wallpaper",
                  ),
                ];
              },
            ),
          ],

        ),

      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child:(senderid!="")?StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Chat")
                    .doc(senderid).collection("Userdata").doc(widget.receiverid)
                    .collection("message").orderBy("timestamp",descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                {
                  if(snapshot.hasData)
                    {
                      if(snapshot.data!.size<=0)
                        {
                          return Center(
                            child: Text("No Messagess"),
                          );
                        }
                      else
                        {
                          return ListView(
                            reverse: true,
                            children: snapshot.data!.docs.map((document){
                              if(document["senderid"]==senderid)
                                {
                                  return Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: EdgeInsets.all(10.0),
                                      padding: EdgeInsets.all(10.0),
                                      child:(document["type"]=="image")?GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => PhotoScreen(
                                                photo :document["msg"].toString(),

                                              )));
                                        },
                                          child: Image.network(document["msg"],width: 100.0,)
                                      ):
                                      Text(document["msg"].toString()),
                                    ),
                                  );
                                }
                              else
                                {
                                  return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        padding: EdgeInsets.all(10.0),
                                        child:(document["type"]=="image")?GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => PhotoScreen(
                                                  photo :document["msg"].toString(),

                                                )));
                                          },
                                            child: Image.network(document["msg"],width: 100.0,)
                                        ):
                                        Text(document["msg"].toString()),
                                      ),
                                  );
                                }

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
              ):Container(),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 60,
                          child: Card(
                            margin: EdgeInsets.only(
                                left: 2, right: 2, bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextFormField(
                              controller: _msg,
                              onTap: (){
                                // FocusScope.of(context).unfocus();
                                setState(() {
                                  _showemoji=false;
                                });
                              },
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              onChanged: (value) {

                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,

                                hintText: "Type a message",
                                hintStyle: TextStyle(color: Colors.grey),
                                prefixIcon: IconButton(
                                  icon: Icon(
                                      Icons.emoji_emotions_outlined
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showemoji= !_showemoji;
                                      final currentFocus = FocusScope.of(context);
                                      if(!currentFocus.hasPrimaryFocus){
                                        currentFocus.unfocus();
                                      }
                                    });

                                  },
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.attach_file),
                                      onPressed: () async{
                                        XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
                                        selectedfile = File(photo!.path);
                                        setState(() {
                                          isloading=true;
                                        });

                                        var uuid = Uuid();

                                        var filename = uuid.v1().toString()+".jpg";

                                        await FirebaseStorage.instance.ref(filename)
                                            .putFile(selectedfile!).whenComplete((){})
                                            .then((filedata)async{
                                          await filedata.ref.getDownloadURL()
                                              .then((fileurl)async{
                                            await FirebaseFirestore.instance.collection("Chat")
                                                .doc(senderid).collection("Userdata").doc(widget.receiverid)
                                                .collection("message").add({
                                              "senderid":senderid,
                                              "reviverod":widget.receiverid,
                                              "msg":fileurl,
                                              "type":"image",
                                              "timestamp":DateTime.now().millisecondsSinceEpoch
                                            }).then((value)async{
                                              await FirebaseFirestore.instance.collection("Chat")
                                                  .doc(widget.receiverid).collection("Userdata")
                                                  .doc(senderid).collection("message").add({
                                                "senderid":senderid,
                                                "reviverod":widget.receiverid,
                                                "msg":fileurl,
                                                "type":"image",
                                                "timestamp":DateTime.now().millisecondsSinceEpoch

                                              }).then((value){
                                                setState(() {
                                                  isloading=false;
                                                });
                                              });
                                            });


                                          });
                                        });



                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () async {
                                        XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                                        selectedfile = File(photo!.path);
                                        setState(() {
                                          isloading=true;
                                        });

                                        var uuid = Uuid();

                                        var filename = uuid.v1().toString()+".jpg";

                                        await FirebaseStorage.instance.ref(filename)
                                            .putFile(selectedfile!).whenComplete((){})
                                            .then((filedata)async{
                                              await filedata.ref.getDownloadURL()
                                                  .then((fileurl)async{
                                                await FirebaseFirestore.instance.collection("Chat")
                                                    .doc(senderid).collection("Userdata").doc(widget.receiverid)
                                                    .collection("message").add({
                                                  "senderid":senderid,
                                                  "reviverod":widget.receiverid,
                                                  "msg":fileurl,
                                                  "type":"image",
                                                  "timestamp":DateTime.now().millisecondsSinceEpoch
                                                }).then((value)async{
                                                  await FirebaseFirestore.instance.collection("Chat")
                                                      .doc(widget.receiverid).collection("Userdata")
                                                      .doc(senderid).collection("message").add({
                                                    "senderid":senderid,
                                                    "reviverod":widget.receiverid,
                                                    "msg":fileurl,
                                                    "type":"image",
                                                    "timestamp":DateTime.now().millisecondsSinceEpoch

                                                  }).then((value){
                                                    setState(() {
                                                      isloading=false;
                                                    });
                                                  });
                                                });


                                              });
                                        });

                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (builder) =>
                                        //             CameraApp()));
                                      },
                                    ),
                                  ],
                                ),
                                contentPadding: EdgeInsets.all(5),
                              ),
                            ),
                          ),
                        ),
                        (isloading)?CircularProgressIndicator(): Padding(
                          padding: const EdgeInsets.only(

                            right: 2,
                            left: 2,
                          ),

                            child: GestureDetector(
                            onTap: (){},
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFF128C7E),
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                onPressed: () async{

                                  var message = _msg.text.toString();
                                  _msg.text="";
                                  print("Reciver id:"+widget.receiverid);
                                  print("sender id:"+senderid);


                                  await FirebaseFirestore.instance.collection("Chat")
                                      .doc(senderid).collection("Userdata").doc(widget.receiverid)
                                      .collection("message").add({
                                    "senderid":senderid,
                                    "reviverod":widget.receiverid,
                                    "msg":message,
                                    "type":"text",
                                    "timestamp":DateTime.now().millisecondsSinceEpoch
                                  }).then((value)async{
                                    await FirebaseFirestore.instance.collection("Chat")
                                        .doc(widget.receiverid).collection("Userdata")
                                        .doc(senderid).collection("message").add({
                                      "senderid":senderid,
                                      "reviverod":widget.receiverid,
                                      "msg":message,
                                      "type":"text",
                                      "timestamp":DateTime.now().millisecondsSinceEpoch

                                    }).then((value){
                                      _msg.text ="";
                                      setState(() {
                                        _showemoji=false;
                                      });
                                    });
                                  });

                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(),

                  ],

                ),
              ),
            ),
            (_showemoji)?SizedBox(
              height: MediaQuery.of(context).size.height*.35,
              child: EmojiPicker(

                textEditingController: _msg,
                config: Config(
                  columns: 7,
                  emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),

                ),
              ),
            ):SizedBox(),
          ],
        ),

      ),
    );
  }
}

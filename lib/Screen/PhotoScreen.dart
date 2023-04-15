
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';



class PhotoScreen extends StatefulWidget {
  var photo="";
  PhotoScreen({required this.photo,});


  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}


class _PhotoScreenState extends State<PhotoScreen> {





  @override



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PhotoScreen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Image.network(widget.photo,),
              ),
              ElevatedButton(onPressed: () async {

    var response = await Dio().get(
      widget.photo,

    options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
    Uint8List.fromList(response.data),
    quality: 60,
    name: "hello");
    print(result);
              },
                  child: Text("Download")),
            ],
          ),
        ),
      ),
    );
  }
}

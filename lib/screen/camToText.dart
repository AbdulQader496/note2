import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';



class textRecog extends StatefulWidget {
  @override
  _textRecogState createState() => _textRecogState();
}

class _textRecogState extends State<textRecog> {
  File pickedImage;
  bool isImageLoaded = false;
  String w="";

  Future pickImage() async {
    // ignore: deprecated_member_use
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {

          print(word.text);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          isImageLoaded
              ? Center(
            child: Container(
              //padding: EdgeInsets.all(30),
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(pickedImage), fit: BoxFit.cover),
              ),
            ),
          )
              : Container(),

          SizedBox(height: 250.0),
          RaisedButton(
            child: Text("Pick an image"),
            onPressed: pickImage,

          ),
          SizedBox(height: 10.0),
          RaisedButton(
            child: Text("Read Text"),
            onPressed: readText,
          ),
          Container(
            child: Text(""+ w),
          )
        ],
      ),
    );
  }
}
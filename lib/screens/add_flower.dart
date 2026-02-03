import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../services/flower_service.dart';

class AddFlowerScreen extends StatefulWidget{
    AddFlowerScreenState createState()=>AddFlowerScreenState();
}

class AddFlowerScreenState extends State<AddFlowerScreen>{

    final nameController=TextEditingController();
    final descriptionController=TextEditingController();

    // Mobile / desktop (non-web) files
    File? image;
    File? pdf;

    // Web (Chrome) uploads as bytes
    Uint8List? webImageBytes;
    Uint8List? webPdfBytes;
    String? webPdfName;

    void uploadImage() async {
        final pickedImage=await ImagePicker().pickImage(source:ImageSource.gallery);
        if(pickedImage!=null){
            setState((){
                image=File(pickedImage.path);
            });
        }
    }

    void uploadPdf() async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
        );

        if (result != null) {
            setState((){
                pdf=File(result.files.single.path!);
            });
        }
    }

    // Web (Chrome) specific upload functions - existing ones remain unchanged
    Future<void> uploadImageWeb() async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.image,
            allowMultiple: false,
            withData: true,
        );

        if (result != null && result.files.single.bytes != null) {
            setState(() {
                webImageBytes = result.files.single.bytes;
            });
        }
    }

    Future<void> uploadPdfWeb() async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
            allowMultiple: false,
            withData: true,
        );

        if (result != null && result.files.single.bytes != null) {
            setState(() {
                webPdfBytes = result.files.single.bytes;
                webPdfName = result.files.single.name;
            });
        }
    }

    void addFlower() async{
        final response=await FlowerService.addFlower(
            name:nameController.text,
            description:descriptionController.text,
            image:image,
            pdf:pdf
        );   
        print(response);
    }

    void addFlowerWeb() async {
        final response = await FlowerService.addFlowerWeb(
            name: nameController.text,
            description: descriptionController.text,
            imageBytes: webImageBytes,
            pdfBytes: webPdfBytes,
        );
        print(response);
    }

    Widget build(BuildContext context){
        return Scaffold(
            appBar:AppBar(
                title:Text('Add Flower'),
            ),
            body:Column(
                children:[
                    TextField(
                        controller:nameController,
                        decoration:InputDecoration(
                            labelText:'Name',
                            hintText:'Enter flower name'
                        )
                    ),
                    TextField(
                        controller:descriptionController,
                        decoration:InputDecoration(
                            labelText:'Description',
                            hintText:'Enter flower description'
                        )
                    ),

                    // Mobile / non-web image upload
                    ElevatedButton(
                        child:Text('Upload Image'),
                        onPressed:uploadImage
                    ),
                    if(image!=null)
                    Image.file(File(image!.path),width:200,height:200,fit:BoxFit.cover),

                    // Web / Chrome image upload
                    ElevatedButton(
                        child:Text('Upload Image (Web)'),
                        onPressed:uploadImageWeb
                    ),
                    if (webImageBytes != null)
                    Image.memory(
                        webImageBytes!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                    ),

                    // Mobile / non-web PDF upload
                    ElevatedButton(
                        child:Text('Upload Pdf'),
                        onPressed:uploadPdf
                    ),
                    if(pdf!=null)
                    Text('Pdf Path :- ${pdf!.path}'),

                    // Web / Chrome PDF upload
                    ElevatedButton(
                        child:Text('Upload Pdf (Web)'),
                        onPressed:uploadPdfWeb
                    ),
                    if (webPdfName != null)
                    Text('Pdf Name (Web) :- $webPdfName'),

                    // Mobile / non-web Add Flower
                    ElevatedButton(
                        child:Text('Add Flower'),
                        onPressed:addFlower
                    ),

                    // Web / Chrome Add Flower
                    ElevatedButton(
                        child:Text('Add Flower (Web)'),
                        onPressed:addFlowerWeb
                    ),
                ]
            )
        );
    }
}
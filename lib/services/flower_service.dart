import '../models/flower.dart';
import 'package:http/http.dart' as http;
import '../utils/local_storage_service.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class FlowerService{

    static String API_URL='http://localhost:4000/flowers';

    static Future<Map<String,dynamic>> addFlower({
        required name,
        required description,
        File? image,
        File? pdf
    })async{

        String? imageUrl;
        String? pdfUrl;

        if(image!=null){
            imageUrl=await LocalStorageService.saveImageFile(image);
        }

        if(pdf!=null){
            pdfUrl=await LocalStorageService.savePdfFile(pdf);
        }

        final response=await http.post(
            Uri.parse(API_URL),
            headers:{'Content-Type':'application/json'},
            body:jsonEncode({
                'name':name,
                'description':description,
                'imageUrl':imageUrl,
                'pdfUrl':pdfUrl
            })
        );

        if(response.statusCode==201){
            return jsonDecode(response.body);
        }
        else{
           
                await LocalStorageService.deleteImageFile(imageUrl!);
           
                await LocalStorageService.deletePdfFile(pdfUrl!);
            

            return jsonDecode(response.body);
        }
    }

    // Web / Chrome specific addFlower method - existing one remains unchanged
    static Future<Map<String, dynamic>> addFlowerWeb({
        required name,
        required description,
        Uint8List? imageBytes,
        Uint8List? pdfBytes,
    }) async {

        String? imageUrl;
        String? pdfUrl;

        if (imageBytes != null) {
            imageUrl = await LocalStorageService.saveImageBytesWeb(imageBytes);
        }

        if (pdfBytes != null) {
            pdfUrl = await LocalStorageService.savePdfBytesWeb(pdfBytes);
        }

        final response = await http.post(
            Uri.parse(API_URL),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
                'name': name,
                'description': description,
                'imageUrl': imageUrl,
                'pdfUrl': pdfUrl,
            }),
        );

        if (response.statusCode == 201) {
            return jsonDecode(response.body);
        } else {
            if (imageUrl != null) {
                await LocalStorageService.deleteImageBytesWeb(imageUrl);
            }

            if (pdfUrl != null) {
                await LocalStorageService.deletePdfBytesWeb(pdfUrl);
            }

            return jsonDecode(response.body);
        }
    }
}
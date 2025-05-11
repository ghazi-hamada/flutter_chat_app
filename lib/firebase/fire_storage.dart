import 'dart:io';
import 'dart:convert';
import 'package:flutter_chat_app/firebase/fire_database.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class FireStorage {
  /// يرفع ملف ويرجع رابط الصورة اللي رجعه السيرفر
  Future<String?> uploadFile( File file) async {
    try {
      final uri = Uri.parse(
        'https://ghaziapp.store/zenat_app_backend/upload_image.php',
      );

      final request =
          http.MultipartRequest('POST', uri)
            ..headers['Authorization'] =
                'Bearer s9TkN2vBq7XjL4gPfWdR6mZoCvYeHtKm'
            ..files.add(
              await http.MultipartFile.fromPath(
                'files', // تأكد أن اسم الحقل صحيح ومطلوب من السيرفر
                file.path,
                filename: basename(file.path),
              ),
            );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success' &&
            responseData['image'] != null) {
          String imageUrl = responseData['image'];
          print('تم رفع الصورة بنجاح: $imageUrl');
          
          return imageUrl;
        } else {
          print(
            'فشل في رفع الصورة: ${responseData['message'] ?? 'لا يوجد رسالة'}',
          );
        }
      } else {
        print('فشل الاتصال بالسيرفر: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ أثناء رفع الصورة: $e');
    }

    return null; // في حالة الفشل
  }
}

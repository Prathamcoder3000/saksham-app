import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import 'dart:convert';

class UploadService {
  static final ImagePicker _picker = ImagePicker();

  // Pick Image
  static Future<File?> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 70);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  // Upload Photo
  static Future<String?> uploadPhoto(String endpoint, File imageFile) async {
    final token = await ApiService.getToken();
    final uri = Uri.parse('${ApiService.baseUrl}$endpoint');
    
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      if (token != null) 'Authorization': 'Bearer $token',
    });
    
    request.files.add(await http.MultipartFile.fromPath(
      'photo',
      imageFile.path,
    ));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['photoUrl'];
      }
      return null;
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }
}

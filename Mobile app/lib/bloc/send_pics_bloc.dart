import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:face_detector_app/bloc/send_pics_event.dart';
import 'package:face_detector_app/bloc/send_pics_state.dart';
import 'package:face_detector_app/utils/baseUrl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class SendPicsBloc extends Bloc<SendPicsEvent, SendPicsState> {
  SendPicsBloc() : super(SendPicsState()) {
    on<SendPictureEvent>((event, emit) async {
      emit(state.copyWith(
          status: PicsStatus
              .uploading , lastUploaded: event.filePath)); // Emitting a state indicating that the picture is being sent

      try {
        var uri = Uri.parse(baseUrl);
        String imagePath = event.filePath;
        var request = http.MultipartRequest('POST', uri)
          ..files.add(await http.MultipartFile.fromPath(
            'picture',
            imagePath,
            contentType:
                MediaType('image', 'jpeg'), // Adjust based on your image type
          ));
        var streamedResponse = await request.send();

        // Convert the StreamedResponse to a Response
        var response = await http.Response.fromStream(streamedResponse);
                var decodedData = json.decode(response.body);
         print(decodedData);
   if (response.statusCode == 200) {
          
        var decodedData = json.decode(response.body);

        final predictedPerson = decodedData["predicted_person"];
        List<String> imageUrlss  = [];
        for(var i in decodedData["image_urls"]){
          imageUrlss.add(i.toString());
          print(i.toString());
        }
        // List<String> imageUrls  = decodedData["image_urls"].map((e) => e.toString()).toList();

        print('you are predicted as $predictedPerson');
        emit(state.copyWith(
            status: PicsStatus.success, predictedName: predictedPerson , imageUrls: imageUrlss));
        }else if(response.statusCode == 400){
            

        final errorMsg = decodedData["predicted_person"];
        print('you are predicted as $errorMsg');
          emit(state.copyWith(
            status: PicsStatus.failure , 
            failureMessage: errorMsg
          ));
        }
      } catch (e) {
        print(e);
         emit(state.copyWith(
        status: PicsStatus.failure
       )); }
    });
  
   on<UploadImageEvent>((event, emit) async {
      emit(state.copyWith(status: PicsStatus.uploading , lastUploaded: event.imagePath));
          try {
        var uri = Uri.parse(baseUrl);
        String imagePath = event.imagePath;
        var request = http.MultipartRequest('POST', uri)
          ..files.add(await http.MultipartFile.fromPath(
            'picture',
            imagePath,
            contentType:
                MediaType('image', 'jpeg'), // Adjust based on your image type
          ));
        var streamedResponse = await request.send();

        // Convert the StreamedResponse to a Response
        var response = await http.Response.fromStream(streamedResponse);
         var decodedData = json.decode(response.body);
         print(decodedData);
   if (response.statusCode == 200) {
          
        var decodedData = json.decode(response.body);

        final predictedPerson = decodedData["predicted_person"];
        List<String> imageUrlss  = [];
        for(var i in decodedData["image_urls"]){
          imageUrlss.add(i.toString());
          print(i.toString());
        }
        // List<String> imageUrls  = decodedData["image_urls"].map((e) => e.toString()).toList();

        print('you are predicted as $predictedPerson');
        emit(state.copyWith(
            status: PicsStatus.success, predictedName: predictedPerson , imageUrls: imageUrlss));
        }else if(response.statusCode == 400){
            var decodedData = json.decode(response.body);

        final errorMsg = decodedData["predicted_person"];
        print('you are predicted as $errorMsg');
          emit(state.copyWith(
            status: PicsStatus.failure , 
            failureMessage: errorMsg
          ));
        }
      } catch (e) {
        print(e);
         emit(state.copyWith(
        status: PicsStatus.failure
       )); }
  
    });
  }
}

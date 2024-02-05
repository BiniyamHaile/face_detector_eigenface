import 'package:camera/camera.dart';
import 'package:face_detector_app/bloc/send_pics_bloc.dart';
import 'package:face_detector_app/bloc/send_pics_event.dart';
import 'package:face_detector_app/pages/preview.dart';
import 'package:face_detector_app/pages/result.dart';
import 'package:face_detector_app/routes/routeNames.dart';
import 'package:face_detector_app/styles/text/appText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

late List<CameraDescription> _cameras;

class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
   CameraController ? controller;

  @override
  void initState() {
   
    _initializeCamera();
    super.initState();
   
  }
Future<void> pickImage() async {
  print('called');
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
      context.read<SendPicsBloc>().add(UploadImageEvent(pickedFile.path));

        Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Result()
      ),
    );
 
  } else {
    print('No image selected');
  }
}


void _initializeCamera()async{
  _cameras = await availableCameras();

   controller = CameraController(_cameras[1], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
}
void takePicture(BuildContext context) async {
    try {
      final image = await controller?.takePicture();
      
      // context.pushNamed(RouteNames.preview ,pathParameters: {'path' :  image.path} ,  queryParameters: {'path' :  image.path} , extra: {'path' :  image.path});
      Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Preview(imagePath: image?.path ?? ''),
      ),
    );
    } catch (e) {
      print(e);
    }
}
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!controller.value.isInitialized) {
    //   return Container();
    // }
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40.h,), 
         controller != null ?  Container(
            height: 460,
            width : 345, 
            // width: double.infinity,
            child: CameraPreview(controller!) 
          ): LinearProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.green) , value: 0.5,  ),
          ElevatedButton(
            child: appText(text: "Capture"),
            onPressed: () {
              takePicture(context);

              
            },
          ), 
           ElevatedButton(
              onPressed: () async {
                pickImage();
               
              },
              child: Text('Pick and Upload Image'),
            ),
        ],
      ),
    );
  }
}
import 'package:face_detector_app/pages/camera.dart';
import 'package:face_detector_app/pages/homepage.dart';
import 'package:face_detector_app/pages/preview.dart';
import 'package:face_detector_app/routes/routeNames.dart';
import 'package:go_router/go_router.dart';

GoRouter routerConfig = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: RouteNames.home,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/camera',
      name: RouteNames.camera,
      builder: (context, state) => CameraApp(),
    ),
    GoRoute(path: '/preview' , 
    name: RouteNames.preview , 

    builder: (context, state) {
     ;
      print(state.pathParameters['path']);
     return Preview(imagePath: state.pathParameters['path']!);
    },
    )
   
  ],
);
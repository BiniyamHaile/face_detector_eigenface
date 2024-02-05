import 'package:camera/camera.dart';
import 'package:face_detector_app/bloc/send_pics_bloc.dart';
import 'package:face_detector_app/pages/homepage.dart';
import 'package:face_detector_app/routes/routes.dart';
import 'package:face_detector_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  
  runApp( ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
     
      builder: (_ , child) {
        return MultiBlocProvider(providers: [
              BlocProvider<SendPicsBloc>(create: 
                (context) => SendPicsBloc() 
              ,)
        ],
        child:  MaterialApp.router(
          
          routerConfig: routerConfig,
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          
    theme: appTheme,
        )
        ,);
      },

    ));
}

import 'package:face_detector_app/routes/routeNames.dart';
import 'package:face_detector_app/styles/text/appText.dart';
import 'package:face_detector_app/utils/value_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding:  EdgeInsets.all(12.0.r),
          child: Column(
                children: [
          SizedBox(
            height: 30.h,
          ),
          Text(
            'Welcome!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              letterSpacing: 1.5,
            )
          ),
          SizedBox(height:   160.h) , 

          Center(child  : appText( text:  'Choose an algorithm', fontWeight:  FontWeight.bold , fontSize: 20.sp)),

          SizedBox(height: 40.h) ,
          Algorithm(
            title: algorithm.EigenFaces  ,
            icon: Icons.face,
            context: context,
         
          ),
          // SizedBox(height: 40.h),
          // Algorithm(
          //   title: algorithm.FisherFaces,
          //   icon: Icons.face,
          //   context: context,
           
          // ),
          // SizedBox(height: 20.h),
          Expanded(child: SizedBox(width: 5.w,)), 
          NextButton,
          SizedBox(height: 20.h),
                ],
              ),
        ));
  }
}


Widget Algorithm({
  required algorithm title,
  required IconData icon,
 
  required BuildContext context,
}) => GestureDetector(
  onTap: (){
    
      algorithmNotifier.value = title;
  
  },
  child: ValueListenableBuilder(
    valueListenable: algorithmNotifier ,
     builder : ( (context, value, child) {
       return Container(
    decoration: BoxDecoration(
      color: value == title ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Padding(
      padding:  EdgeInsets.symmetric(vertical: 10.h),
      child: Align(
        alignment: Alignment.center,
        child: appText(text:
       title == algorithm.EigenFaces ? 'EigenFaces' : 'FisherFaces'
         , fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    ),
  );
     }))

);


Widget NextButton  = ValueListenableBuilder(
  valueListenable: algorithmNotifier,
  builder: (context, value, child) {
    return Container(
      height: 50.h,
      // width: .w,
      decoration: BoxDecoration(
        color: value == algorithm.None ?  Theme.of(context).colorScheme.secondary :  Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: GestureDetector(
        onTap: (){
          if (value != algorithm.None) {
           context.goNamed(RouteNames.camera);
          }
        },
        child: Center(
          child: appText(
            text: 'Next',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          

        ),
      ),
    );
  },
);
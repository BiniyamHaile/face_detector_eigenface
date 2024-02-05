import 'dart:io';

import 'package:face_detector_app/bloc/send_pics_bloc.dart';
import 'package:face_detector_app/bloc/send_pics_state.dart';
import 'package:face_detector_app/styles/text/appText.dart';
import 'package:face_detector_app/utils/baseUrl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.secondary,),
        ),
        title: appText(text: 'Result' , fontSize: 20.sp , fontWeight: FontWeight.bold),
      ),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: 8.r , vertical: 10.h),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(height: 20.h,),
           
              BlocBuilder<SendPicsBloc, SendPicsState>(
                builder: (context, state) {
                  if(state.status == PicsStatus.success){
                    return Column(
                      children: [
                         Container(
                            margin: EdgeInsets.only(bottom: 7.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: Colors.grey), 
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],

                            ),
                            child: Image.file(File(state.lastUploaded)),
                          ), 
                        appText(text: "Predicted as : ${state.predictedName}" , fontSize: 18.sp), 
                        SizedBox(height: 20.h,),
                        Column(
                          children: state.imageUrls.map((e) => Container(
                            margin: EdgeInsets.only(bottom: 7.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: Colors.grey), 
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],

                            ),
                            child: Image.network("$staticUrl$e"),
                          )).toList(),
                        ),

                        
                      ],
                    );}
                  else if(state.status == PicsStatus.failure){
                    return Column(
                      children: [
                        SizedBox(height: 200.h,),
                       Align(
                        alignment: Alignment.center,
                       child:   appText(text: state.failureMessage , fontWeight: FontWeight.bold, fontSize: 24.sp , color: Theme.of(context).colorScheme.error)
                       )
                      ],
                    
                    );
                  }
                    return Center(
                      child: CircularProgressIndicator(strokeWidth: 4, color: Colors.grey,),
                    );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
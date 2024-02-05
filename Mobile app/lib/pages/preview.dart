import 'dart:io';

import 'package:face_detector_app/bloc/send_pics_bloc.dart';
import 'package:face_detector_app/bloc/send_pics_event.dart';
import 'package:face_detector_app/bloc/send_pics_state.dart';
import 'package:face_detector_app/pages/result.dart';
import 'package:face_detector_app/styles/text/appText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Preview extends StatefulWidget {
  final String imagePath;
   Preview({
    required this.imagePath
   });

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  void initState() {

    super.initState();
  }
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
        title: appText(text: 'Preview Image' , fontSize: 20.sp , fontWeight: FontWeight.bold ),
        elevation: 0,
      ),
      body: Padding(padding: EdgeInsets.all(10.w) ,  
        child: BlocListener<SendPicsBloc, SendPicsState>(
          listener: (context, state) {
            print("state.status ${state.status}");
            if(state.status != PicsStatus.initial){
               Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Result()
      ),
    );
            }
          },
          child:  Column(
              children: [
                SizedBox(height: 20.h,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3.sp, 
                      color: Theme.of(context).primaryColor
                    ) , 
             ),
               child: Image.file(File(widget.imagePath)),
            
                ) , 
                ElevatedButton(
                  onPressed: () {
                    context.read<SendPicsBloc>().add(SendPictureEvent(filePath: widget.imagePath));
                  },
                  child: appText(text: 'Send'),
                )
              ],
            )
            
        )
      ),
    );
  }
}
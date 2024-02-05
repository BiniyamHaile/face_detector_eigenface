import 'package:flutter/material.dart';

enum algorithm {
  EigenFaces,
  FisherFaces, 
  None

}
ValueNotifier<algorithm> algorithmNotifier = ValueNotifier<algorithm>(algorithm.None);
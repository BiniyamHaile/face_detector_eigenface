abstract class SendPicsEvent {}

class SendPictureEvent extends SendPicsEvent{
  final String filePath;
  SendPictureEvent({
    required this.filePath
  });
}

class UploadImageEvent extends SendPicsEvent {
  final String imagePath;

  UploadImageEvent(this.imagePath);
}
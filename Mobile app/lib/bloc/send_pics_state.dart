enum PicsStatus{
  uploading,
  sending, 
  analysing, 
  success, 
  failure, 
  notFace, 
  unknown, 
  initial
}
class SendPicsState {
  PicsStatus status ; 
  String predictedName; 
  List<String> imageUrls = [];
  String failureMessage = '';
  String lastUploaded;
  SendPicsState({
    this.status = PicsStatus.initial, 
    this.predictedName = '' , 
    this.imageUrls = const [] , 
    this.failureMessage = '', 
    this.lastUploaded = ''
  }) ;

  SendPicsState copyWith({
    PicsStatus ? status, 
    String  ? predictedName , 
    List<String> ? imageUrls , 
    String ? failureMessage, 
    String ? lastUploaded
  }) => SendPicsState(
    status: status ?? this.status, 
    predictedName: predictedName ?? this.predictedName , 
    imageUrls: imageUrls ?? this.imageUrls , 
    failureMessage: failureMessage ?? this.failureMessage, 
    lastUploaded: lastUploaded ?? this.lastUploaded
  );

}

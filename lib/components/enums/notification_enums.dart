enum NotificationEnum {
  onReact('onReact'),
  onAcceptRequest("onAcceptRequest"),
  ;

  const NotificationEnum(this.type);
  final String type;
}

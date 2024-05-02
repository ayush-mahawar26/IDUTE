import 'package:idute_app/model/iq_model.dart';

abstract class IqStates {}

class GettingIq extends IqStates {}

class FetchedIq extends IqStates {
  IqModel model;
  FetchedIq({required this.model});
}

class ErrorIq extends IqStates {
  String err;
  ErrorIq({required this.err});
}

class IqInitialState extends IqStates {}

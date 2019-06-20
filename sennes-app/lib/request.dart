import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

@JsonSerializable()
class Request {
  @JsonKey(name: 'fridge_id')
  String fridgeId;
  String method;
  int state;
  List<String> barcodes;
  String update;

  Request({this.fridgeId, this.method, this.state, this.barcodes, this.update});

  factory Request.getUpdates(fridgeId, state) {
    return Request(fridgeId: fridgeId, method: "get_updates", state: state);
  }

  factory Request.addUpdate(fridgeId, update) {
    return Request(fridgeId: fridgeId, method: "add_update", update: update);
  }

  factory Request.barcodeInfo(barcodes) {
    return Request(method: "barcode_info", barcodes: barcodes);
  }

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}

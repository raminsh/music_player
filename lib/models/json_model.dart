import 'dart:convert';

abstract class JsonModel<T> {
  T fromJsonMap(Map<String, dynamic> json);
  Map<String, dynamic> toJsonMap();

  String toJson() => json.encode(this.toJsonMap());
  T fromJson(String str) => fromJsonMap(json.decode(str));

  /// A helper function that converst a json map of array of objects of type T to List<T>.
  List<T> fromJsonList(List<dynamic> json) {
      return json != null ? (json).map((e) => fromJsonMap(e)).toList() : null;
  }
}
import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class setLike {
  bool isLike;
  setLike({
    required this.isLike,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isLike': isLike,
    };
  }

  factory setLike.fromMap(Map<String, dynamic> map) {
    return setLike(
      isLike: map['isLike'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory setLike.fromJson(String source) =>
      setLike.fromMap(json.decode(source) as Map<String, dynamic>);
}

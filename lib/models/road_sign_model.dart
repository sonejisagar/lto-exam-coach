import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class RoadSignModel {
  final String id;
  final String name;
  final String category;
  final String meaning;
  final String description;
  final String usage;
  final String signType;
  final String? sourceReference;

  const RoadSignModel({
    required this.id,
    required this.name,
    required this.category,
    required this.meaning,
    required this.description,
    required this.usage,
    required this.signType,
    this.sourceReference,
  });

  /// Provides an accessible spoken/screen-reader label describing the sign.
  String get semanticLabel => '$name. $category sign. $meaning';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'meaning': meaning,
      'description': description,
      'usage': usage,
      'signType': signType,
      if (sourceReference != null) 'sourceReference': sourceReference,
    };
  }

  factory RoadSignModel.fromMap(Map<String, dynamic> map) {
    return RoadSignModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      meaning: map['meaning'] as String? ?? '',
      description: map['description'] as String? ?? '',
      usage: map['usage'] as String? ?? '',
      signType: map['signType'] as String? ?? '',
      sourceReference: map['sourceReference'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoadSignModel.fromJson(String source) =>
      RoadSignModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoadSignModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'RoadSignModel(id: $id, name: $name, category: $category)';
}

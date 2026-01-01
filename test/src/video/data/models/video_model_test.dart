import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/src/video/data/models/video_model.dart';
import 'package:itube/src/video/domain/entities/video.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late final VideoModel tVideoModel;
  late final DataMap tMap;
  setUpAll(() {
    final fixtureString = fixture('video.json');
    tMap = jsonDecode(fixtureString) as DataMap;
    tVideoModel = VideoModel.empty().copyWith();
  });
  test('should be a subclass of Video entity', () {
    expect(tVideoModel, isA<Video>());
  });
  group('fromMap', () {
    test('should return a valid model when the map is valid', () {
      final result = VideoModel.fromMap(tMap);
      expect(result, isA<VideoModel>());
      expect(result, equals(tVideoModel));
    });
  });
  group('toMap', () {
    test('should return a JSON map containing the proper data', () {
      final result = tVideoModel.toMap();
      expect(result, isA<DataMap>());
      expect(result, equals(tMap));
    });
  });
  group('copyWith', () {
    test('should return a copy of the model with updated fields', () {
      final result = tVideoModel.copyWith(id: 'Updated id');
      expect(result, isA<VideoModel>());
      expect(result.id, equals('Updated id'));
      // Ensure other fields remain unchanged
      expect(result.userId, equals(tVideoModel.userId));
    });
    test('should return the same instance when no parameters are provided', () {
      final result = tVideoModel.copyWith();
      expect(result, equals(tVideoModel));
    });
  });
  group('fromJson', () {
    test('should return a valid model when the JSON string is valid', () {
      final jsonString = jsonEncode(tMap);
      final result = VideoModel.fromJson(jsonString);
      expect(result, isA<VideoModel>());
      expect(result, equals(tVideoModel));
    });
  });
  group('toJson', () {
    test('should return a JSON string containing the proper data', () {
      final result = tVideoModel.toJson();
      expect(result, isA<String>());
      // Parse both to compare as maps (order-independent)
      final resultMap = jsonDecode(result) as DataMap;
      expect(resultMap, equals(tMap));
    });
  });
}

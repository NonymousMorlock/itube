import 'dart:convert';

import 'package:itube/core/enums/processing_status.dart';
import 'package:itube/core/enums/visibility_status.dart';
import 'package:itube/core/typedefs.dart';
import 'package:itube/src/video/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.videoS3Key,
    required super.visibility,
    required super.processingStatus,
  });

  VideoModel.empty()
    : this(
        id: 'Test String',
        userId: 'Test String',
        title: 'Test String',
        description: 'Test String',
        videoS3Key: 'Test String',
        visibility: VisibilityStatus.values.first,
        processingStatus: ProcessingStatus.values.first,
      );

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(jsonDecode(source) as DataMap);

  VideoModel.fromMap(DataMap map)
    : this(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        videoS3Key: map['video_s3_key'] as String,
        visibility: VisibilityStatus.fromString(map['visibility'] as String),
        processingStatus: ProcessingStatus.fromString(
          map['processing_status'] as String,
        ),
      );

  VideoModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? videoS3Key,
    VisibilityStatus? visibility,
    ProcessingStatus? processingStatus,
  }) {
    return VideoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      videoS3Key: videoS3Key ?? this.videoS3Key,
      visibility: visibility ?? this.visibility,
      processingStatus: processingStatus ?? this.processingStatus,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'video_s3_key': videoS3Key,
      'visibility': visibility.value,
      'processing_status': processingStatus.value,
    };
  }

  String toJson() => jsonEncode(toMap());
}

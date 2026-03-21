import 'package:equatable/equatable.dart';
import 'package:itube/core/enums/processing_status.dart';
import 'package:itube/core/enums/visibility_status.dart';

class Video extends Equatable {
  const Video({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.videoS3Key,
    required this.visibility,
    required this.processingStatus,
  });

  Video.empty()
    : this(
        id: 'Test String',
        userId: 'Test String',
        title: 'Test String',
        description: 'Test String',
        videoS3Key: 'Test String',
        visibility: VisibilityStatus.values.first,
        processingStatus: ProcessingStatus.values.first,
      );

  final String id;

  final String userId;

  final String title;

  final String description;

  final String videoS3Key;

  final VisibilityStatus visibility;

  final ProcessingStatus processingStatus;

  String get thumbnailUrl {
    const baseUrl = String.fromEnvironment('THUMBNAIL_BASE_URL');
    final thumbnailKey = videoS3Key
        .replaceAll('.mp4', '.jpg')
        .replaceAll('videos/', 'thumbnails/');
    return '$baseUrl/$thumbnailKey';
  }

  String get dashManifestUrl {
    const baseManifestUrl = String.fromEnvironment(
      'CLOUDFRONT_VIDEOS_BASE_URL',
    );
    return '$baseManifestUrl/$videoS3Key/manifest.mpd';
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    videoS3Key,
    visibility,
    processingStatus,
  ];
}

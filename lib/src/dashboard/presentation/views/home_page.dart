import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/utils/app_utils.dart';
import 'package:itube/core/enums/processing_status.dart';
import 'package:itube/core/presentation/views/error_page.dart';
import 'package:itube/core/presentation/widgets/adaptive_progress_indicator.dart';
import 'package:itube/core/presentation/widgets/video_card.dart';
import 'package:itube/src/dashboard/presentation/views/empty_content_view.dart';
import 'package:itube/src/video/domain/entities/video.dart';
import 'package:itube/src/video/presentation/adapters/video_adapter.dart';
import 'package:itube/src/video/presentation/views/upload_video_page.dart';
import 'package:itube/src/video/presentation/views/watch_page.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Video> _videos = [];

  @override
  void initState() {
    super.initState();
    unawaited(context.read<VideoAdapter>().getAllVideos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoAdapter, VideoState>(
      listener: (_, state) {
        if (state case VideoError(:final message, :final title)) {
          AppUtils.showErrorToast(context, message: message, title: title);
        } else if (state case AllVideosLoaded(:final videos)) {
          _videos = videos;
        }
      },
      builder: (context, state) {
        if (state is VideoLoading) {
          return const AdaptiveProgressIndicator();
        } else if (state case VideoError(:final message, :final title)) {
          return ErrorPage(
            title: title ?? 'Error',
            message: message,
            canGoBack: false,
          );
        } else if (state is AllVideosLoaded && _videos.isEmpty) {
          return EmptyContentView(
            onAction: () {
              context.go(UploadVideoPage.path);
            },
            actionLabel: 'Upload Video',
          );
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1600), // Ultra-wide cap
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<VideoAdapter>().getAllVideos();
              },
              child: ResponsiveBuilder(
                builder: (context, sizingInfo) {
                  // --- COLUMN LOGIC ---
                  var crossAxisCount = 1;
                  if (sizingInfo.isTablet) crossAxisCount = 2;
                  if (sizingInfo.isDesktop) crossAxisCount = 3;
                  if (sizingInfo.screenSize.width > 1400) crossAxisCount = 4;

                  // Add extra bottom padding on mobile to account for
                  // the floating navbar
                  final bottomPadding = sizingInfo.isDesktop ? 24.0 : 120.0;

                  return GridView.builder(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 32,
                      childAspectRatio:
                          16 / 14, // Adjust for thumbnail + meta height
                    ),
                    itemCount: _videos.length,
                    itemBuilder: (context, index) {
                      final video = _videos[index];
                      return VideoCard(
                        key: ValueKey(video.id),
                        title: video.title,
                        // authorName: null,
                        thumbnailUrl: video.thumbnailUrl,
                        // avatarUrl: video.avatar,
                        isProcessing:
                            video.processingStatus ==
                            ProcessingStatus.inProgress,
                        isFailed:
                            video.processingStatus == ProcessingStatus.failed,
                        onTap: () {
                          context.go(
                            Uri(
                              path: WatchPage.path,
                              queryParameters: {
                                WatchPage.videoIdQueryParamName: video.id,
                              },
                            ).toString(),
                            extra: video,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

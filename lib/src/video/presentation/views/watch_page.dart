import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:itube/core/presentation/views/error_page.dart';
import 'package:itube/core/presentation/widgets/adaptive_progress_indicator.dart';
import 'package:itube/src/video/domain/entities/video.dart' as domain;
import 'package:itube/src/video/presentation/adapters/video_adapter.dart';
import 'package:itube/src/video/presentation/widgets/status_badge.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart' hide VideoState;

class WatchPage extends StatefulWidget {
  const WatchPage({required this.video, required this.videoId, super.key});

  static const path = '/watch';
  static const videoIdQueryParamName = 'v';

  final domain.Video? video;
  final String videoId;

  @override
  State<WatchPage> createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> {
  domain.Video? _video;
  late final Player _player;
  late final VideoController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.video != null) {
      _video = widget.video;
      unawaited(_initPlayer(videoUrl: _video!.dashManifestUrl));
    } else {
      unawaited(context.read<VideoAdapter>().getVideoById(id: widget.videoId));
    }
  }

  Future<void> _initPlayer({required String videoUrl}) async {
    _player = Player();

    _controller = VideoController(_player);

    await _player.open(Media(videoUrl));

    if (mounted) {
      setState(() => _isPlayerReady = true);
    }
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktopPlatform =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux);
    final videoControls = isDesktopPlatform
        ? MaterialDesktopVideoControls
        : AdaptiveVideoControls;

    return BlocConsumer<VideoAdapter, VideoState>(
      listener: (context, state) {
        if (state case VideoLoaded(:final video)) {
          _video = video;
          unawaited(_initPlayer(videoUrl: video.dashManifestUrl));
        }
      },
      builder: (context, state) {
        if (state is VideoLoading) {
          return const AdaptiveProgressIndicator();
        } else if (state case VideoError(:final message, :final title)) {
          return ErrorPage(
            title: title ?? 'Error',
            message: message,
          );
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // THE PLAYER
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ColoredBox(
                        color: Colors.black,
                        child: _isPlayerReady
                            ? Video(
                                controller: _controller,
                                controls: videoControls,
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    // THE INFO
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _video!.title,
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(8),
                            // Meta Row
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: Colors.grey.shade400,
                                  size: 20,
                                ),
                                const Gap(8),
                                Text(
                                  'User ${_video!.userId.substring(0, 8)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const Spacer(),
                                StatusBadge(
                                  videoVisibility: _video!.visibility,
                                ),
                              ],
                            ),
                            const Gap(24),
                            // Description
                            if (_video!.description.isNotEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _video!.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

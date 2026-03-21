import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:itube/src/video/presentation/views/video_preview_view.dart';
import 'package:itube/src/video/presentation/widgets/metadata_form.dart';
import 'package:itube/src/video/presentation/widgets/publish_bar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StudioLayoutView extends StatelessWidget {
  const StudioLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      key: const ValueKey('studio'),
      builder: (context, sizingInfo) {
        // --- MOBILE/TABLET (Vertical Scroll) ---
        if (sizingInfo.isMobile || sizingInfo.isTablet) {
          return const SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VideoPreviewView(isMobile: true),
                Gap(32),
                MetadataForm(),
                Gap(48),
                PublishBar(isDesktop: false),
              ],
            ),
          );
        }

        // --- DESKTOP (Split Screen) ---
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              // Left: Media Assets
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: VideoPreviewView(isMobile: false),
                ),
              ),
              Gap(48),
              // Right: Metadata form
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: MetadataForm(),
                      ),
                    ),
                    Divider(),
                    Gap(16),
                    PublishBar(isDesktop: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

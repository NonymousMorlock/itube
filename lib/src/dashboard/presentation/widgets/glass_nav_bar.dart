import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/routing/route_constants.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:itube/src/dashboard/presentation/widgets/glass_nav_item.dart';
import 'package:itube/src/video/presentation/views/upload_video_page.dart';

class GlassNavBar extends StatelessWidget {
  const GlassNavBar({required this.currentRoute, super.key});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(40));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          // The Frost: Native Gaussian Blur
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            // Taller than standard for touch targets
            height: 72,
            decoration: BoxDecoration(
              // The Tint: Translucent white with subtle gradient
              color: context.theme.colorScheme.surface.withValues(alpha: 0.8),
              borderRadius: borderRadius,
              // The Glass Edge: Subtle white border
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GlassNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isSelected: currentRoute == RouteConstants.initialRoute,
                  onTap: () {
                    context.go(RouteConstants.initialRoute);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    context.go(UploadVideoPage.path);
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                GlassNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

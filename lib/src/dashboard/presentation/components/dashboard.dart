import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:itube/app/routing/route_constants.dart';
import 'package:itube/src/dashboard/presentation/widgets/glass_nav_bar.dart';
import 'package:itube/src/video/presentation/views/upload_video_page.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Wraps the main content with the appropriate navigation structure
class Dashboard extends StatefulWidget {
  const Dashboard({
    required this.routerState,
    required this.child,
    super.key,
  });

  final Widget child;
  final GoRouterState routerState;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hideNavController;
  bool _isNavVisible = true;

  @override
  void initState() {
    super.initState();
    _hideNavController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1, // Start visible
    );
  }

  // --- Scroll Logic for Mobile ---
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0 && notification is UserScrollNotification) {
      final direction = notification.direction;
      if (direction == ScrollDirection.reverse && _isNavVisible) {
        _isNavVisible = false;
        unawaited(_hideNavController.reverse()); // Hide
      } else if (direction == ScrollDirection.forward && !_isNavVisible) {
        _isNavVisible = true;
        unawaited(_hideNavController.forward()); // Show
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideNavController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: ResponsiveBuilder(
          builder: (context, sizingInfo) {
            // --- DESKTOP LAYOUT ---
            if (sizingInfo.deviceScreenType == DeviceScreenType.desktop) {
              return Row(
                children: [
                  // Fixed Side Rail - Clean Version
                  NavigationRail(
                    selectedIndex: switch (widget.routerState.matchedLocation) {
                      RouteConstants.initialRoute => 0,
                      _ => 0,
                    },
                    onDestinationSelected: (index) {
                      switch (index) {
                        case 0:
                          context.go(RouteConstants.initialRoute);
                      }
                    },
                    // Use 'all' so we can control spacing via theme
                    // but we will hide labels via empty text
                    // if we want icon-only
                    labelType: NavigationRailLabelType.none,
                    backgroundColor: Colors.white,
                    groupAlignment: -1,
                    // Push strictly to top
                    minWidth: 80,
                    // Compact width
                    // Leading Logo
                    leading: const Column(
                      children: [
                        SizedBox(height: 24),
                        Icon(
                          Icons.play_circle_filled_rounded,
                          size: 32,
                          color: Colors.black,
                        ),
                        SizedBox(height: 32), // Gap between logo and first item
                      ],
                    ),

                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home_filled),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Profile'),
                      ),
                    ],

                    // Trailing Action Button (Upload)
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Tooltip(
                        message: 'Upload Video',
                        child: Material(
                          color: Colors.black,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () {
                              context.go(UploadVideoPage.path);
                            },
                            customBorder: const CircleBorder(),
                            child: const SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Divider
                  VerticalDivider(
                    thickness: 1,
                    width: 1,
                    color: Colors.grey.shade100,
                  ),

                  // Content
                  Expanded(child: widget.child),
                ],
              );
            }

            // --- MOBILE/TABLET LAYOUT ---
            return Stack(
              children: [
                // Content fills screen
                SafeArea(child: widget.child),
                // Floating Glass Pill
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 1), // Below screen
                          end: Offset.zero, // On screen
                        ).animate(
                          CurvedAnimation(
                            parent: _hideNavController,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: GlassNavBar(
                      currentRoute: widget.routerState.matchedLocation,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

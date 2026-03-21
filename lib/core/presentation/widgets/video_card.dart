import 'package:flutter/material.dart';
import 'package:itube/core/extensions/context_extensions.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({
    required this.title,
    required this.thumbnailUrl,
    required this.onTap,
    this.authorName,
    this.avatarUrl,
    this.isProcessing = false,
    this.isFailed = false,
    super.key,
  });

  final String title;
  final String? authorName;
  final String thumbnailUrl;
  final String? avatarUrl;
  final bool isProcessing;
  final bool isFailed;
  final VoidCallback onTap;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Determine if interaction should be blocked
    final isInteractive = !widget.isProcessing && !widget.isFailed;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isInteractive
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTap: isInteractive ? widget.onTap : null,
        child: AnimatedScale(
          scale: _isHovered && isInteractive ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Thumbnail Section ---
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. The Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ColoredBox(
                          color: Colors.grey.shade100,
                          child: Image.network(
                            widget.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => ColoredBox(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 2. Hover Overlay (Desktop Play Icon)
                    if (_isHovered && isInteractive)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),

                    // 3. Processing Overlay
                    if (widget.isProcessing)
                      _buildStatusOverlay(
                        icon: Icons.hourglass_top_rounded,
                        label: 'PROCESSING',
                        color: Colors.black,
                      ),

                    // 4. Failed Overlay
                    if (widget.isFailed)
                      _buildStatusOverlay(
                        icon: Icons.error_outline_rounded,
                        label: 'FAILED',
                        color: context.theme.colorScheme.error,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- Meta Section ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar (Smart Placeholder)
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: widget.avatarUrl != null
                        ? NetworkImage(widget.avatarUrl!)
                        : null,
                    onBackgroundImageError: widget.avatarUrl != null
                        ? (_, _) {
                            // Handled silently
                          }
                        : null,
                    child: widget.avatarUrl == null
                        ? Icon(
                            Icons.person,
                            color: Colors.grey.shade500,
                            size: 20,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            fontSize: 15,
                          ),
                        ),
                        if (widget.authorName != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.authorName!,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusOverlay({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

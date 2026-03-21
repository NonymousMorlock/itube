import 'package:flutter/material.dart';
import 'package:itube/core/enums/visibility_status.dart';
import 'package:itube/src/video/presentation/extensions/context_extensions.dart';

class VisibilityPicker extends StatelessWidget {
  const VisibilityPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ValueListenableBuilder(
        valueListenable: context.uploadController.visibilityNotifier,
        builder: (_, status, _) {
          return Row(
            children: VisibilityStatus.values.map((status) {
              final controller = context.uploadController;
              final isSelected = controller.visibilityNotifier.value == status;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.visibilityNotifier.value = status;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      status.value,
                      textAlign: .center,
                      style: TextStyle(
                        fontWeight: isSelected ? .bold : .normal,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

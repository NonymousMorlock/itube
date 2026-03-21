import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:itube/core/extensions/context_extensions.dart';
import 'package:itube/src/video/presentation/extensions/context_extensions.dart';
import 'package:itube/src/video/presentation/widgets/visibility_picker.dart';

class MetadataForm extends StatelessWidget {
  const MetadataForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: context.uploadController.titleController,
          decoration: const InputDecoration(
            labelText: 'Title (required)',
            hintText: 'Add a title that describes your video',
            prefixIcon: Icon(Icons.title_rounded),
          ),
        ),
        const Gap(24),
        TextFormField(
          controller: context.uploadController.descriptionController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Description',
            hintText: 'Tell viewers about your video',
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: Icon(Icons.description_outlined),
            ),
          ),
        ),
        const Gap(24),
        Text(
          'Visibility',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: .bold,
          ),
        ),
        const Gap(12),
        const VisibilityPicker(),
      ],
    );
  }
}

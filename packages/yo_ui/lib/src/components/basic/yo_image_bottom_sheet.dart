import 'package:flutter/material.dart';

import '../../../yo_ui_base.dart';

class YoImageBottomSheet {
  static Future<void> show({
    required BuildContext context,
    required String imageUrl,
    String? title,
    List<Widget>? actions,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (title != null)
                      Expanded(child: YoText.titleMedium(title)),
                    ...?actions,
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Image content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: YoImage.network(url: imageUrl, fit: BoxFit.contain),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Screen showcasing theme customization
class ThemeDemoScreen extends StatefulWidget {
  const ThemeDemoScreen({super.key});

  @override
  State<ThemeDemoScreen> createState() => _ThemeDemoScreenState();
}

class _ThemeDemoScreenState extends State<ThemeDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Themes & Colors'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '36 Color Schemes',
            style: context.yoHeadlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Industry-specific themes with light/dark mode',
            style: context.yoBodyMedium.copyWith(color: context.gray600),
          ),
          const SizedBox(height: 24),

          // Color swatches
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildColorSwatch(context, 'Primary', context.primaryColor),
              _buildColorSwatch(context, 'Secondary', context.secondaryColor),
              _buildColorSwatch(context, 'Success', context.successColor),
              _buildColorSwatch(context, 'Error', context.errorColor),
              _buildColorSwatch(context, 'Warning', context.warningColor),
              _buildColorSwatch(context, 'Info', context.infoColor),
            ],
          ),

          const SizedBox(height: 32),
          Text(
            'Shadow Examples',
            style: context.yoHeadlineMedium,
          ),
          const SizedBox(height: 16),

          // Shadow examples
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildShadowExample(context, 'Soft', YoBoxShadow.soft(context)),
              _buildShadowExample(context, 'Float', YoBoxShadow.float(context)),
              _buildShadowExample(context, 'Glow', YoBoxShadow.glow(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatch(BuildContext context, String name, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildShadowExample(
    BuildContext context,
    String name,
    List<BoxShadow> shadow,
  ) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadow,
      ),
      child: Center(
        child: Text(
          name,
          style: context.yoBodyMedium,
        ),
      ),
    );
  }
}

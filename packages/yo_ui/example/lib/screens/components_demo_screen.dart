import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Screen showcasing all YoUI components
class ComponentsDemoScreen extends StatelessWidget {
  const ComponentsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Components'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoryCard(
            context,
            'Buttons',
            'Primary, Secondary, Outline, Ghost',
            Icons.touch_app,
          ),
          _buildCategoryCard(
            context,
            'Forms',
            'TextField, Dropdown, Checkbox, Radio, etc.',
            Icons.edit_note,
          ),
          _buildCategoryCard(
            context,
            'Navigation',
            'AppBar, BottomNav, Drawer, TabBar',
            Icons.navigation,
          ),
          _buildCategoryCard(
            context,
            'Feedback',
            'Dialog, Toast, Snackbar, Loading',
            Icons.feedback,
          ),
          _buildCategoryCard(
            context,
            'Display',
            'Cards, Avatar, Badge, Chip',
            Icons.view_module,
          ),
          _buildCategoryCard(
            context,
            'Charts',
            'Line, Bar, Pie, Sparkline',
            Icons.show_chart,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: YoCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: context.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.yoBodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: context.yoBodySmall.copyWith(
                        color: context.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

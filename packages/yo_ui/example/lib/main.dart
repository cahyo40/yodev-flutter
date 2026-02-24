import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

import 'screens/components_demo_screen.dart';
import 'screens/new_components_screen.dart';
import 'screens/theme_demo_screen.dart';

void main() {
  runApp(const YoUIExampleApp());
}

/// Home screen with navigation to different demos
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YoUI Component Library'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          YoCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.widgets,
                    size: 64,
                    color: context.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'YoUI Example App',
                    style: context.yoHeadlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '90+ Components | 36 Themes | 51 Fonts',
                    style: context.yoBodyMedium.copyWith(
                      color: context.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Navigation Cards
          _buildNavigationCard(
            context,
            title: '🎉 New Components (19)',
            subtitle: 'Forms, Tables, Stepper, Toast, and more',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NewComponentsScreen(),
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildNavigationCard(
            context,
            title: '🧩 All Components',
            subtitle: 'Browse all 90+ YoUI components',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ComponentsDemoScreen(),
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildNavigationCard(
            context,
            title: '🎨 Themes & Colors',
            subtitle: '36 color schemes and customization',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ThemeDemoScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return YoCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
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
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: context.yoBodyMedium.copyWith(
                      color: context.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.gray400,
            ),
          ],
        ),
      ),
    );
  }
}

/// Example app showcasing all YoUI components
class YoUIExampleApp extends StatelessWidget {
  const YoUIExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YoUI Example',
      theme: YoTheme.lightTheme(context),
      darkTheme: YoTheme.darkTheme(context),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

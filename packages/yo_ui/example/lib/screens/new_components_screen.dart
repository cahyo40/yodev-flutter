import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

/// Screen showcasing new components added in v0.0.2
class NewComponentsScreen extends StatefulWidget {
  const NewComponentsScreen({super.key});

  @override
  State<NewComponentsScreen> createState() => _NewComponentsScreenState();
}

class _NewComponentsScreenState extends State<NewComponentsScreen> {
  int _currentStep = 0;
  List<String> _selectedChips = ['Flutter', 'Dart'];
  RangeValues _priceRange = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Components'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // OTP Field
          _buildSection(
            'YoOtpField',
            'OTP/PIN input with auto-focus',
            YoOtpField(
              length: 6,
              onCompleted: (pin) {
                YoToast.success(
                  context: context,
                  message: 'OTP entered: $pin',
                );
              },
            ),
          ),

          // Toast Demo
          _buildSection(
            'YoToast',
            'Toast notifications',
            Row(
              children: [
                Expanded(
                  child: YoButton(
                    text: 'Success',
                    variant: YoButtonVariant.primary,
                    onPressed: () => YoToast.success(
                      context: context,
                      message: 'Operation successful!',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: YoButton(
                    text: 'Error',
                    variant: YoButtonVariant.secondary,
                    onPressed: () => YoToast.error(
                      context: context,
                      message: 'Something went wrong',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Shimmer
          _buildSection(
            'YoShimmer',
            'Loading skeleton',
            Column(
              children: [
                YoShimmer.card(height: 100),
                const SizedBox(height: 12),
                YoShimmer.listTile(),
              ],
            ),
          ),

          // Chip Input
          _buildSection(
            'YoChipInput',
            'Tag input with suggestions',
            YoChipInput(
              chips: _selectedChips,
              suggestions: ['React', 'Vue', 'Angular', 'Svelte'],
              onChanged: (chips) => setState(() => _selectedChips = chips),
            ),
          ),

          // Range Slider
          _buildSection(
            'YoRangeSlider',
            'Dual-thumb range slider',
            YoRangeSlider(
              values: _priceRange,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (values) => setState(() => _priceRange = values),
            ),
          ),

          // Expansion Panel
          _buildSection(
            'YoExpansionPanel',
            'Accordion panels',
            YoExpansionPanelList(
              expandOnlyOne: true,
              children: [
                YoExpansionPanelItem(
                  header: const Text('Panel 1'),
                  body: const Text('Content for panel 1'),
                ),
                YoExpansionPanelItem(
                  header: const Text('Panel 2'),
                  body: const Text('Content for panel 2'),
                ),
              ],
            ),
          ),

          // Breadcrumb
          _buildSection(
            'YoBreadcrumb',
            'Navigation trail',
            YoBreadcrumb(
              items: [
                YoBreadcrumbItem(
                  label: 'Home',
                  icon: Icons.home,
                  onTap: () {},
                ),
                YoBreadcrumbItem(
                  label: 'Products',
                  onTap: () {},
                ),
                YoBreadcrumbItem(label: 'Detail'),
              ],
            ),
          ),

          // Stepper
          _buildSection(
            'YoStepper',
            'Multi-step wizard',
            YoStepper(
              currentStep: _currentStep,
              steps: [
                YoStep(
                  title: 'Step 1',
                  content: const Text('First step content'),
                ),
                YoStep(
                  title: 'Step 2',
                  content: const Text('Second step content'),
                ),
                YoStep(
                  title: 'Step 3',
                  content: const Text('Final step content'),
                ),
              ],
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() => _currentStep++);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep--);
                }
              },
            ),
          ),

          // Banner
          _buildSection(
            'YoBanner',
            'Info banner',
            YoBanner(
              message: 'This is an informational banner',
              type: YoBannerType.info,
            ),
          ),

          // More components button
          const SizedBox(height: 24),
          YoButton(
            text: 'See More Components',
            variant: YoButtonVariant.outline,
            onPressed: () {
              YoToast.info(
                context: context,
                message: 'Check ComponentsDemoScreen for more!',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.yoHeadlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: context.yoBodySmall.copyWith(color: context.gray600),
        ),
        const SizedBox(height: 12),
        child,
        const SizedBox(height: 24),
      ],
    );
  }
}

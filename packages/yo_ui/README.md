# 🎨 YoUI - Flutter UI Component Library

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
A comprehensive, production-ready Flutter UI library with **90+ components**, **36 color schemes**, **51 fonts**, and a complete design system for building beautiful, consistent applications.

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🎯 **90+ Components** | Forms, Tables, Navigation, Feedback, Charts, and more |
| 🎨 **36 Color Schemes** | Industry-specific themes with AMOLED dark mode |
| 🔤 **51 Google Fonts** | Pre-configured fonts via `YoFonts` enum |
| 🌓 **Theme Support** | Light & dark mode with easy customization |
| 📱 **Responsive** | Adaptive layouts for mobile, tablet, desktop |
| 🎭 **26+ Shadows** | Comprehensive shadow system with elevation levels |
| 📊 **Charts** | Line, Bar, Pie/Donut charts with fl_chart |
| 🚀 **Production Ready** | Battle-tested components with zero errors |

## 🆕 What's New in v0.0.3 (Latest)

### 📅 Month Picker Improvements
- **YoMonthPicker** - Now shows custom dialog with month/year only (no date picker)
  - Returns `DateTimeRange` (first to last day of selected month)
  - 3x4 month grid with year navigation
- **YoDialogPicker.monthRange()** - New method for month selection dialog

### 🎨 Styling Consistency
- **YoIconPicker** & **YoColorPicker** now use `YoTextFormField` for consistent styling

> ⚠️ **Breaking Change**: `YoMonthPicker` now uses `DateTimeRange` instead of `DateTime`

> See [CHANGELOG.md](CHANGELOG.md) for full details

## 📦 Installation

```yaml
dependencies:
  yo_ui:
    path: packages/yo_ui
```

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Apply Theme

```dart
import 'package:yo_ui/yo_ui.dart';

MaterialApp(
  theme: YoTheme.lightTheme(context),
  darkTheme: YoTheme.darkTheme(context),
  themeMode: ThemeMode.system,
  // Or use a specific color scheme:
  // theme: YoTheme.lightTheme(context, YoColorScheme.techPurple),
)
```

### 2. Use Components

```dart
Scaffold(
  body: Column(
    children: [
      YoText.headlineMedium('Welcome to YoUI'),
      
      // New OTP Field
      YoOtpField(
        length: 6,
        onCompleted: (pin) => verifyOTP(pin),
      ),
      
      // Buttons
      YoButton.primary(
        text: 'Get Started',
        onPressed: () {},
      ),
      
      // Toast notifications
      YoButton.secondary(
        text: 'Show Toast',
        onPressed: () => YoToast.success(
          context: context,
          message: 'Welcome!',
        ),
      ),
      
      // Cards
      YoCard(
        child: YoText.bodyMedium('Beautiful components'),
      ),
    ],
  ),
)
```

### 3. Run Example App

Explore all components interactively:

```bash
cd example
flutter run
```

The example app includes:
- 🎉 Interactive demos for 19 new components
- 🎨 Theme customization showcase
- 📱 Responsive layout examples
- 💡 Code samples for every component

---

## 🎨 Customization

### Custom Color Scheme

Create your own color scheme by using `setCustomPalette()`:

```dart
import 'package:yo_ui/yo_ui.dart';

void main() {
  // Set custom color palette before runApp()
  setCustomPalette(
    light: YoCorePalette(
      text: Color(0xFF1A1A2E),
      background: Color(0xFFFAFAFF),
      primary: Color(0xFF6C63FF),      // Your primary brand color
      secondary: Color(0xFF9D4EDD),    // Secondary color
      accent: Color(0xFF00D9A5),       // Accent color for highlights
    ),
    dark: YoCorePalette(
      text: Color(0xFFF0F0FF),
      background: Color(0xFF000000),   // Pure black for AMOLED
      primary: Color(0xFF8B7FFF),
      secondary: Color(0xFFB76EFF),
      accent: Color(0xFF1FF8DF),
    ),
  );

  runApp(MyApp());
}

// Then use YoColorScheme.custom in your theme
MaterialApp(
  theme: YoTheme.lightTheme(context, YoColorScheme.custom),
  darkTheme: YoTheme.darkTheme(context, YoColorScheme.custom),
)
```

### Available Color Schemes (36)

| Category | Schemes |
|----------|---------|
| **Tech** | `techPurple`, `codingDark`, `cryptoModern` |
| **Healthcare** | `oceanTeal`, `healthcarePro`, `wellnessMint` |
| **Business** | `corporateModern`, `realEstatePro`, `posRetail` |
| **Lifestyle** | `foodAmber`, `travelCoral`, `fitnessEnergy` |
| **Creative** | `creativeMagenta`, `musicVibes`, `artGallery` |
| **Entertainment** | `gamingNeon`, `neonCyberpunk`, `kidsLearning` |
| **Dark Themes** | `amoledBlack`, `midnightBlue`, `carbonDark`, `minimalMono` |

---

### Custom Fonts

Use `YoFonts` enum for type-safe font selection (51 fonts available):

```dart
import 'package:yo_ui/yo_ui.dart';

void main() {
  // Using YoFonts enum (recommended)
  YoTextTheme.setFont(
    primary: YoFonts.nunito,       // Headline & Title (default: poppins)
    secondary: YoFonts.openSans,   // Body text (default: inter)
    mono: YoFonts.firaSans,        // Numbers & code (default: Space Mono)
  );

  runApp(MyApp());
}
```

**Available Fonts (YoFonts enum):**

| Category | Fonts |
|----------|-------|
| **Sans Serif** | `roboto`, `openSans`, `lato`, `montserrat`, `poppins`, `inter`, `dmSans`, `nunito`, `quicksand`, `ubuntu` |
| **Display** | `oswald`, `raleway`, `bebasNeue`, `anton`, `teko`, `righteous` |
| **Elegant** | `playfairDisplay`, `merriweather`, `crimsonText`, `spectral`, `ebGaramond`, `gelasio` |
| **Modern** | `manrope`, `sora`, `lexend`, `spaceGrotesk`, `publicSans`, `archivo` |
| **Casual** | `cabin`, `karla`, `barlow`, `workSans`, `heebo`, `mukta` |

**Using custom font string (for fonts not in enum):**

```dart
// For fonts not available in YoFonts enum
YoTextTheme.setFontFamily(
  primary: 'YourCustomFont',
  mono: 'JetBrains Mono',
);
```

---

### Complete Custom Setup Example

```dart
import 'package:flutter/material.dart';
import 'package:yo_ui/yo_ui.dart';

void main() {
  // 1. Custom Colors
  setCustomPalette(
    light: YoCorePalette(
      text: Color(0xFF2D3436),
      background: Color(0xFFFDFDFD),
      primary: Color(0xFF0984E3),
      secondary: Color(0xFF74B9FF),
      accent: Color(0xFF00CEC9),
    ),
    dark: YoCorePalette(
      text: Color(0xFFDFE6E9),
      background: Color(0xFF000000),
      primary: Color(0xFF74B9FF),
      secondary: Color(0xFF0984E3),
      accent: Color(0xFF00CEC9),
    ),
  );

  // 2. Custom Fonts using YoFonts enum
  YoTextTheme.setFont(
    primary: YoFonts.montserrat,
    secondary: YoFonts.sourceSans3,
    mono: YoFonts.firaSans,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Custom App',
      theme: YoTheme.lightTheme(context, YoColorScheme.custom),
      darkTheme: YoTheme.darkTheme(context, YoColorScheme.custom),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
```

---

---

## 🧩 Component Showcase

### 🆕 New Components (v0.0.2)

#### Form & Input
```dart
// OTP Field - Auto-focus, paste support
YoOtpField(
  length: 6,
  obscureText: true,
  onCompleted: (pin) => verify(pin),
)

// Search with debounce & suggestions
YoSearchField(
  hintText: 'Search products...',
  suggestions: ['iPhone', 'MacBook', 'iPad'],
  onSearch: (query) => search(query),
)

// Chip Input - Tags with autocomplete
YoChipInput(
  chips: ['Flutter', 'Dart'],
  suggestions: ['React', 'Vue'],
  maxChips: 5,
  onChanged: (chips) => updateTags(chips),
)

// Range Slider - Dual thumb
YoRangeSlider(
  values: RangeValues(20, 80),
  min: 0,
  max: 100,
  onChanged: (values) => filter(values),
)

// File Upload with progress
YoFileUpload(
  maxFiles: 5,
  onFilesSelected: (files) => upload(files),
)
```

#### Navigation & Workflow
```dart
// Stepper - Multi-step wizard
YoStepper(
  currentStep: 0,
  type: YoStepperType.vertical,
  steps: [
    YoStep(
      title: 'Personal Info',
      content: PersonalInfoForm(),
    ),
    YoStep(
      title: 'Address',
      content: AddressForm(),
    ),
  ],
  onStepContinue: () => nextStep(),
)

// Pagination
YoPagination(
  currentPage: 1,
  totalPages: 10,
  onPageChanged: (page) => loadPage(page),
)

// Breadcrumb navigation
YoBreadcrumb(
  items: [
    YoBreadcrumbItem(
      label: 'Home',
      icon: Icons.home,
      onTap: () => goHome(),
    ),
    YoBreadcrumbItem(label: 'Products'),
  ],
)
```

#### Display & Layout
```dart
// Carousel - Auto-play slider
YoCarousel(
  images: imageUrls,
  autoPlay: true,
  height: 200,
)

// Data Table - Sortable & selectable
YoDataTable(
  columns: [
    YoDataColumn(label: 'Name'),
    YoDataColumn(label: 'Email'),
  ],
  rows: data.map((item) => YoDataRow(
    cells: [
      YoDataCell(text: item.name),
      YoDataCell(text: item.email),
    ],
  )).toList(),
)

// Expansion Panel - Accordion
YoExpansionPanelList(
  expandOnlyOne: true,
  children: [
    YoExpansionPanelItem(
      header: Text('FAQ 1'),
      body: Text('Answer 1'),
    ),
  ],
)

// Masonry Grid - Pinterest style
YoMasonryGrid(
  columns: 2,
  children: items.map((item) => ItemCard(item)).toList(),
)
```

#### Feedback & Notifications
```dart
// Toast - Beautiful notifications
YoToast.success(
  context: context,
  message: 'Payment successful!',
)

YoToast.error(
  context: context,
  message: 'Failed to process',
  duration: Duration(seconds: 5),
)

// Shimmer - Loading skeleton
YoShimmer.card(height: 120)
YoShimmer.listTile()
YoShimmer.image(height: 200)

// Modal - Bottom sheet
YoModal.show(
  context: context,
  title: 'Filter Options',
  height: 0.8, // 80% of screen
  child: FilterForm(),
)

// Banner - Info banner
YoBanner(
  message: 'New update available',
  type: YoBannerType.info,
  dismissible: true,
  action: TextButton(
    onPressed: () => update(),
    child: Text('Update'),
  ),
)
```

---

### 🎨 Buttons

```dart
// Primary button
YoButton.primary(text: 'Primary', onPressed: () {})

// Secondary button
YoButton.secondary(text: 'Secondary', onPressed: () {})

// Outline button (default: primary border)
YoButton.outline(text: 'Outline', onPressed: () {})

// Outline with custom border color
YoButton.outline(
  text: 'Custom Border',
  onPressed: () {},
  borderColor: Colors.red,
)

// Outline border follows text color
YoButton.outline(
  text: 'Follow Text',
  onPressed: () {},
  textColor: Colors.green,
  borderColorFollowsText: true,
)

// Ghost button (no background)
YoButton.ghost(text: 'Ghost', onPressed: () {})

// Custom styled button
YoButton.custom(
  text: 'Custom',
  onPressed: () {},
  backgroundColor: Colors.purple,
)

// Button styles: modern, minimalist, pill, sharp
YoButton.pill(text: 'Pill Button', onPressed: () {})
YoButton.modern(text: 'Modern Button', onPressed: () {})
```

### Display Cards

```dart
// Product Card (E-commerce & POS)
YoProductCard(
  imageUrl: 'https://...',
  title: 'Product Name',
  price: 99.99,
  stock: 15,
  onEdit: () {},
  onDelete: () {},
)

// Destination Card (Travel)
YoDestinationCard.featured(
  imageUrl: 'https://...',
  title: 'Bali, Indonesia',
  location: 'Southeast Asia',
  rating: 4.8,
  price: 1200,
)

// Profile Card (Social)
YoProfileCard.cover(
  avatarUrl: 'https://...',
  name: 'John Doe',
  stats: [YoProfileStat(value: '1.2K', label: 'Followers')],
)

// Article Card (Blog/News)
YoArticleCard.featured(
  imageUrl: 'https://...',
  title: 'Article Title',
  category: 'Technology',
  readTime: 5,
)
```

### Charts (fl_chart)

```dart
// Line Chart
YoLineChart.simple(
  data: [YoChartData(x: 1, y: 10), YoChartData(x: 2, y: 25)],
  title: 'Sales Trend',
  curved: true,
  filled: true,
)

// Bar Chart
YoBarChart(
  data: [
    YoChartData(x: 0, y: 100, label: 'Jan'),
    YoChartData(x: 1, y: 150, label: 'Feb'),
  ],
  title: 'Monthly Revenue',
)

// Pie/Donut Chart
YoPieChart.donut(
  data: [
    YoPieData(value: 35, label: 'Product A'),
    YoPieData(value: 25, label: 'Product B'),
  ],
  centerText: '60%',
)

// Sparkline (mini chart)
YoSparkLine(data: [10, 15, 8, 20, 18, 25])
```

### Navigation

```dart
// Bottom Navigation
YoBottomNav(
  currentIndex: 0,
  items: [
    YoBottomNavItem(icon: Icons.home, label: 'Home'),
    YoBottomNavItem(icon: Icons.search, label: 'Search'),
  ],
  onTap: (index) {},
)

// Sidebar
YoSidebar(
  items: [
    YoSidebarItem(icon: Icons.dashboard, label: 'Dashboard'),
    YoSidebarItem(icon: Icons.settings, label: 'Settings'),
  ],
)

// Drawer
YoDrawer(
  header: YoDrawerHeader(title: 'App Name', subtitle: 'user@email.com'),
  items: [
    YoDrawerItem(icon: Icons.home, title: 'Home'),
    YoDrawerItem.divider(),
    YoDrawerItem.header('Settings'),
  ],
  footer: YoDrawerFooter(text: 'Made with YoUI', version: '1.1.0'),
)
```

### Forms

```dart
// Dropdown with validation
YoDropDown<String>(
  value: selectedValue,
  labelText: 'Category',
  hintText: 'Select category',
  isRequired: true,
  errorText: hasError ? 'Required field' : null,
  items: [
    YoDropDownItem(value: 'tech', label: 'Technology'),
    YoDropDownItem(value: 'health', label: 'Healthcare'),
  ],
  onChanged: (value) {},
)
```

### Pickers

```dart
// Date Picker
YoDatePicker(
  selectedDate: selectedDate,
  labelText: 'Birth Date',
  onDateChanged: (date) => setState(() => selectedDate = date),
)

// Time Picker
YoTimePicker(
  selectedTime: selectedTime,
  labelText: 'Appointment Time',
  onTimeChanged: (time) => setState(() => selectedTime = time),
)

// Date Time Picker
YoDateTimePicker(
  selectedDateTime: selectedDateTime,
  labelText: 'Event Date & Time',
  onDateTimeChanged: (dt) => setState(() => selectedDateTime = dt),
)

// Date Range Picker
YoDateRangePicker(
  selectedRange: dateRange,
  labelText: 'Booking Period',
  onRangeChanged: (range) => setState(() => dateRange = range),
)

// Compact Date Range Picker
YoDateRangePicker.compact(
  selectedRange: dateRange,
  labelText: 'Filter by Date',
  startLabel: 'From',
  endLabel: 'To',
  onRangeChanged: (range) => setState(() => dateRange = range),
)

// Month Picker (returns DateTimeRange for entire month)
YoMonthPicker(
  selectedRange: monthRange, // DateTimeRange
  labelText: 'Select Month',
  onMonthChanged: (range) => setState(() => monthRange = range),
  // range.start = first day of month, range.end = last day of month
)

// Dialog Pickers (programmatic)
final date = await YoDialogPicker.date(context: context);
final time = await YoDialogPicker.time(context: context);
final dateTime = await YoDialogPicker.dateTime(context: context);
final dateRange = await YoDialogPicker.dateRange(context: context);
final monthRange = await YoDialogPicker.monthRange(context: context); // NEW
```

### Icon Picker

```dart
// Inline Icon Picker
YoIconPicker(
  selectedIcon: selectedIcon,
  onIconSelected: (icon) => setState(() => selectedIcon = icon),
  initialCategory: YoIconCategory.action,
  showSearch: true,
  showCategories: true,
)

// Icon Picker Button (triggers picker on tap)
YoIconPickerButton(
  selectedIcon: selectedIcon,
  labelText: 'App Icon',
  hintText: 'Choose an icon',
  onIconSelected: (icon) => setState(() => selectedIcon = icon),
)

// Show as Bottom Sheet
final icon = await YoIconPicker.showAsBottomSheet(
  context: context,
  selectedIcon: currentIcon,
  title: 'Select Icon',
);

// Show as Dialog
final icon = await YoIconPicker.showAsDialog(
  context: context,
  selectedIcon: currentIcon,
  title: 'Choose Icon',
);

// Get icons by category
final actionIcons = YoIcons.byCategory(YoIconCategory.action);
final socialIcons = YoIcons.byCategory(YoIconCategory.social);

// Search icons
final searchResults = YoIcons.search('home');
```

**Available Categories (18):**
- Action, Alert, Audio/Video, Communication, Content
- Device, Editor, File, Hardware, Home
- Image, Maps, Navigation, Notification
- Places, Social, Toggle

### Color Picker

```dart
// Inline Color Picker
YoColorPicker(
  selectedColor: selectedColor,
  onColorSelected: (color) => setState(() => selectedColor = color),
  initialPalette: YoColorPalette.material,
  showHexInput: true,
  showRgbSliders: true,
  showOpacity: false,
)

// Color Picker Button (triggers picker on tap)
YoColorPickerButton(
  selectedColor: selectedColor,
  labelText: 'Theme Color',
  hintText: 'Choose a color',
  onColorSelected: (color) => setState(() => selectedColor = color),
)

// Show as Bottom Sheet
final color = await YoColorPicker.showAsBottomSheet(
  context: context,
  selectedColor: currentColor,
  title: 'Select Color',
  showOpacity: true,
);

// Show as Dialog
final color = await YoColorPicker.showAsDialog(
  context: context,
  selectedColor: currentColor,
  title: 'Choose Color',
);

// Get colors by palette
final materialColors = YoColorPresets.byPalette(YoColorPalette.material);
final pastelColors = YoColorPresets.byPalette(YoColorPalette.pastel);

// Search colors
final searchResults = YoColorPresets.search('blue');
```

**Available Palettes (3):**
- `YoColorPalette.material` - Material Design colors
- `YoColorPalette.pastel` - Soft pastel colors
- `YoColorPalette.grayscale` - Black to white gradients

**Features:**
- HSV color sliders (Hue, Saturation, Brightness)
- Hex color input with live preview
- Optional opacity/alpha slider
- Predefined color palettes grid
- Color preview with shadow effect

### Image Picker

```dart
// Pick from gallery
final result = await YoImagePicker.pickFromGallery();
if (result != null) {
  print('Selected: ${result.path}');
}

// Pick from camera
final photo = await YoImagePicker.pickFromCamera();

// Show source picker (camera/gallery chooser)
final image = await YoImagePicker.showSourcePicker(
  context: context,
  config: YoImagePickerConfig.compressed,
);

// Pick multiple images
final images = await YoImagePicker.pickMultiple(limit: 5);

// Pick video
final video = await YoImagePicker.pickVideoFromGallery();

// Avatar Picker Widget
YoAvatarPicker(
  imagePath: avatarPath,
  imageUrl: avatarUrl,
  size: 100,
  onImageSelected: (result) => setState(() => avatarPath = result.path),
)

// Image Picker Button
YoImagePickerButton(
  imagePath: imagePath,
  labelText: 'Profile Photo',
  onImageSelected: (result) => setState(() => imagePath = result.path),
)
```

**Config Presets:**
- `YoImagePickerConfig.defaultConfig` - Default settings
- `YoImagePickerConfig.compressed` - 1024x1024, 80% quality
- `YoImagePickerConfig.highQuality` - 100% quality
- `YoImagePickerConfig.thumbnail` - 256x256, 70% quality
- `YoImagePickerConfig.avatar` - 512x512, 85% quality

### File Picker

```dart
// Pick any file
final file = await YoFilePicker.pickAny();
if (file != null) {
  print('File: ${file.name}, Size: ${file.formattedSize}');
}

// Pick specific types
final image = await YoFilePicker.pickImage();
final pdf = await YoFilePicker.pickPdf();
final doc = await YoFilePicker.pickDocument();
final video = await YoFilePicker.pickVideo();

// Pick with custom extensions
final csv = await YoFilePicker.pickCustom(
  extensions: ['csv', 'xlsx'],
);

// Pick multiple files
final files = await YoFilePicker.pickMultiple(
  type: YoFileType.image,
);

// Pick directory (desktop/mobile)
final directory = await YoFilePicker.pickDirectory();

// File Picker Button
YoFilePickerButton(
  selectedFile: selectedFile,
  labelText: 'Attachment',
  fileType: YoFileType.any,
  onFileSelected: (file) => setState(() => selectedFile = file),
)

// Drop Zone
YoFileDropZone(
  multiple: true,
  fileType: YoFileType.image,
  onFilesSelected: (files) => print('Dropped ${files.length} files'),
)

// File List Tile
YoFileListTile(
  file: selectedFile,
  onRemove: () => setState(() => selectedFile = null),
)
```

**File Types:**
- `YoFileType.any` - All files
- `YoFileType.image` - Images only
- `YoFileType.video` - Videos only
- `YoFileType.audio` - Audio files
- `YoFileType.media` - Images & videos
- `YoFileType.custom` - Custom extensions

### Feedback

```dart
// Dialogs
YoDialog.show(context: context, title: 'Title', content: 'Message');
YoConfirmDialog.showDestructive(context: context, title: 'Delete?');
YoBottomSheet.showList(context: context, items: [...]);

// Loading
YoLoading.spinner()
YoLoading.dots()
YoLoadingOverlay.showWhile(context: context, task: () async {});

// States
YoEmptyState.noData(title: 'No data', onAction: () {})
YoEmptyState.error(error: exception, onRetry: () {})
```

### Timeline

```dart
YoTimeline(
  events: [
    YoTimelineEvent(
      title: 'Order Placed',
      description: 'Your order has been confirmed',
      date: DateTime.now(),
      isCompleted: true,
    ),
    YoTimelineEvent(
      title: 'Processing',
      isActive: true,
    ),
  ],
)

// Stepper style
YoTimeline.stepper(events: [...], currentStep: 1)
```

---

## 📐 Adaptive Design

```dart
// Check device type
if (YoAdaptive.isMobile(context)) { }
if (YoAdaptive.isTablet(context)) { }
if (YoAdaptive.isDesktop(context)) { }

// Responsive values
YoAdaptive.value(
  context,
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
)

// Adaptive spacing
YoSpace.adaptiveMd(context)
YoPadding.page(context)
```

---

## 🛠️ Utilities

### Date Formatting

```dart
YoDateFormatter.formatDate(DateTime.now())       // '07 Dec 2024'
YoDateFormatter.formatRelativeTime(date)         // '2 hours ago'
YoDateFormatter.isToday(date)                    // true/false
```

### ID Generation

```dart
YoIdGenerator.uuid()                    // UUID v4
YoIdGenerator.numericId(length: 8)      // '12345678'
YoIdGenerator.userId()                  // 'USR_aB3xY8pQ'
```

### Connectivity

```dart
await YoConnectivity.initialize();
bool isOnline = YoConnectivity.isConnected;

YoConnectivity.addListener((connected) {
  // Handle connection changes
});
```

### Text Input Formatters

Format user input in TextFormFields with pre-built formatters:

```dart
// Currency formatter (generic)
TextFormField(
  inputFormatters: [CurrencyTextInputFormatter()],
  // Input: 1000000 -> Output: 1.000.000
)

// Indonesian Currency with Rp prefix
TextFormField(
  inputFormatters: [IndonesiaCurrencyFormatter()],
  // Input: 1000000 -> Output: Rp 1.000.000
)

// Phone number formatter (configurable)
TextFormField(
  inputFormatters: [PhoneNumberFormatter(separator: '-')],
  // Input: 081234567890 -> Output: 0812-3456-7890
)

// Indonesian phone number (auto-detect +62 or 0xxx)
TextFormField(
  inputFormatters: [IndonesiaPhoneFormatter()],
  // Input: 6281234567890 -> Output: +62 812 3456 7890
  // Input: 081234567890 -> Output: 0812 3456 7890
)

// Credit card number
TextFormField(
  inputFormatters: [CreditCardFormatter()],
  // Input: 1234567890123456 -> Output: 1234 5678 9012 3456
)

// Decimal number with configurable decimal places
TextFormField(
  inputFormatters: [DecimalTextInputFormatter(decimalPlaces: 2)],
  // Input: 123.456 -> Output: 123,45
)

// Case formatters
TextFormField(
  inputFormatters: [UpperCaseTextFormatter()],
  // Input: hello -> Output: HELLO
)

TextFormField(
  inputFormatters: [LowerCaseTextFormatter()],
  // Input: HELLO -> Output: hello
)
```

---

## 🔧 Context Extensions


Quick access to theme values via BuildContext:

```dart
// Text styles
context.yoHeadlineLarge
context.yoBodyMedium
context.yoLabelSmall

// Colors
context.primaryColor
context.backgroundColor
context.textColor
context.gray500
context.errorColor
context.successColor

// Screen info
context.yoScreenWidth
context.yoIsMobile
context.yoIsTablet
context.yoIsDesktop

// Spacing
context.yoSpacingSm   // 8
context.yoSpacingMd   // 16
context.yoSpacingLg   // 24
context.yoSpacingXl   // 32
```

---

## 📚 Dependencies

| Package | Purpose |
|---------|---------|
| `google_fonts` | Typography |
| `cached_network_image` | Image caching |
| `connectivity_plus` | Network state |
| `crypto` | Hash ID generation |
| `device_info_plus` | Device information |
| `file_picker` | File system picking |
| `image_picker` | Camera/gallery picker |
| `intl` | Date/number formatting |
| `photo_view` | Image viewer |
| `fl_chart` | Charts & graphs |

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

**Built with ❤️ for the Flutter community**

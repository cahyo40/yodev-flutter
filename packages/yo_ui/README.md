# 🎨 YoUI - Flutter UI Component Library

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.0.4-blue.svg)](CHANGELOG.md)

Library UI Flutter siap produksi dengan **90+ komponen**, **36 color scheme**, **51 font**, dan design system lengkap.

## ✨ Highlights

| Fitur | Jumlah |
|-------|--------|
| 🎯 Components | 90+ (Form, Table, Navigation, Chart, Feedback, dll) |
| 🎨 Color Schemes | 36 (Tech, Healthcare, Business, Creative, Dark) |
| 🔤 Google Fonts | 51 (Sans-serif, Serif, Monospace, Display) |
| 🎭 Shadows | 26+ varian (elevation, neumorphic, colored) |
| 📊 Charts | Line, Bar, Pie/Donut, Sparkline (fl_chart) |
| 📱 Responsive | Mobile, Tablet, Desktop adaptive layout |

## 📦 Instalasi

```yaml
# pubspec.yaml
dependencies:
  yo_ui:
    path: packages/yo_ui  # dari monorepo
    # atau
    git:
      url: https://github.com/cahyo40/yodev-flutter.git
      path: packages/yo_ui
```

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Setup Theme

```dart
import 'package:yo_ui/yo_ui.dart';

void main() {
  // Setup font (opsional, panggil sebelum runApp)
  YoTextTheme.setFont(
    primary: YoFonts.poppins,
    secondary: YoFonts.inter,
  );
  runApp(const MyApp());
}

// Di MaterialApp:
MaterialApp(
  // Parameter: (BuildContext context, [YoColorScheme scheme])
  theme: YoTheme.lightTheme(context, YoColorScheme.techPurple),
  darkTheme: YoTheme.darkTheme(context, YoColorScheme.techPurple),
  themeMode: ThemeMode.system,
)
```

### 2. Gunakan Komponen

```dart
Column(children: [
  YoText.headlineMedium('Welcome to YoUI'),
  YoButton.primary(text: 'Get Started', onPressed: () {}),
  YoCard(child: YoText.bodyMedium('Beautiful card')),
  YoToast.success(context: context, message: 'Done!'),
])
```

---

## 🧩 Komponen

### Basic

```dart
YoButton.primary(text: 'Submit', onPressed: () {})
YoButton.secondary(text: 'Cancel', onPressed: () {})
YoButton.outline(text: 'Details', onPressed: () {})
YoButton.ghost(text: 'Skip', onPressed: () {})
YoButton.pill(text: 'Tag', onPressed: () {})
YoButton.modern(text: 'Action', onPressed: () {})

YoScaffold(appBar: AppBar(title: YoText.heading('Title')), body: content)
YoCard(child: content)
YoFAB(onPressed: () {}, icon: Icons.add)
YoImage.network(url: 'https://...', width: 200)
YoImage.circle(url: 'https://...', radius: 40)
YoDivider()
```

### Display

```dart
YoText('Regular')
YoText.heading('Title')
YoText.headlineLarge('Large Title')
YoText.bodyMedium('Body text')

YoProductCard(imageUrl: '...', title: 'Product', price: 99.99, stock: 15)
YoProfileCard.cover(avatarUrl: '...', name: 'John Doe', stats: [...])
YoArticleCard.featured(imageUrl: '...', title: 'Article', category: 'Tech')
YoDestinationCard.featured(imageUrl: '...', title: 'Bali', rating: 4.8)

YoCarousel(images: ['url1', 'url2'], autoPlay: true, height: 200)
YoDataTable(columns: [...], rows: [...], onSort: (col, asc) {})
YoAvatar(url: '...', radius: 24)
YoBadge(count: 5, child: Icon(Icons.notifications))
YoRating(value: 4.5, onChanged: (r) {})
YoTimeline(items: [...])
YoKanbanBoard(columns: [...])
YoChatBubble(message: 'Hello!', isMe: true, time: DateTime.now())
YoCalendar(selectedDate: DateTime.now(), onDateSelected: (d) {})
```

### Form & Input

```dart
YoForm(onSubmit: (values) {}, children: [...])
YoSearchField(hintText: 'Search...', onSearch: (q) {}, debounceMs: 300)
YoOtpField(length: 6, onCompleted: (pin) => verify(pin))
YoDropdown<String>(label: 'Category', items: [...], onChanged: (v) {})
YoChipInput(chips: ['Tag1'], maxChips: 5, onChanged: (c) {})
YoRangeSlider(values: RangeValues(20, 80), onChanged: (v) {})
YoFileUpload(maxFiles: 5, onFilesSelected: (f) {})
```

### Feedback & State

```dart
const YoLoading()
YoLoading(message: 'Loading...')
YoErrorState(message: 'Error occurred', onRetry: () {})
YoEmptyState(message: 'No data', icon: Icons.inbox)

YoToast.success(context: context, message: 'Saved!')
YoToast.error(context: context, message: 'Failed!')
YoToast.info(context: context, message: 'Info')

YoShimmer.card(height: 120)
YoShimmer.listTile()
YoSkeletonCard(count: 3)

YoConfirmDialog(title: 'Delete?', content: YoText('Cannot undo'), onConfirm: () {})
YoDialog.show(context: context, title: 'Title', content: widget)
YoBottomSheet.show(context: context, title: 'Options', child: widget)
YoModal.show(context: context, title: 'Modal', child: widget)
YoBanner(message: 'New update!', type: YoBannerType.info, dismissible: true)
YoProgress(value: 0.75, label: '75%')
YoLoadingOverlay(isLoading: true, child: content)
```

### Navigation

```dart
YoAppbar(title: 'Title', actions: [...])
YoBottomNav(currentIndex: 0, items: [...], onTap: (i) {})
YoDrawer(header: YoDrawerHeader(...), items: [...])
YoSidebar(items: [...], selectedIndex: 0, onItemTap: (i) {})
YoStepper(currentStep: 0, steps: [...])
YoPagination(currentPage: 1, totalPages: 10, onPageChanged: (p) {})
YoBreadcrumb(items: [...])
YoTabbar(tabs: ['Tab1', 'Tab2'], onChanged: (i) {})
```

### Charts

```dart
YoLineChart.simple(data: [...], title: 'Sales', curved: true, filled: true)
YoBarChart(data: [...], title: 'Revenue')
YoPieChart.donut(data: [...], centerText: '60%')
YoSparkLine(data: [10, 15, 8, 20, 18, 25])
```

### Pickers

```dart
YoDatePicker(selectedDate: date, onDateChanged: (d) {})
YoTimePicker(selectedTime: time, onTimeChanged: (t) {})
YoDateTimePicker(selectedDateTime: dt, onDateTimeChanged: (dt) {})
YoDateRangePicker(selectedRange: range, onRangeChanged: (r) {})
YoMonthPicker(selectedRange: range, onMonthChanged: (r) {})  // returns DateTimeRange
YoColorPicker(selectedColor: color, onColorSelected: (c) {})
YoIconPicker(selectedIcon: icon, onIconSelected: (i) {})
YoImagePicker.showSourcePicker(context: context, config: YoImagePickerConfig.compressed)
YoFilePicker.show(context: context, onFileSelected: (f) {})
```

### Layout & Utility

```dart
YoResponsive(mobile: MobileView(), tablet: TabletView(), desktop: DesktopView())
YoAdaptive(breakpoint: 600, below: CompactView(), above: ExpandedView())
YoInfiniteScroll(onLoadMore: () {}, hasMore: true, child: listView)
YoColumn(spacing: 16, children: [...])
YoRow(spacing: 8, children: [...])
YoGrid(columns: 2, children: [...])
YoMasonryGrid(columns: 2, children: [...])  // Pinterest-style
const YoSpace.md()  // SizedBox(height: 16)
YoPadding.page(child: widget)
```

---

## 🎨 Color Schemes (36)

| Kategori | Schemes |
|----------|---------|
| **Professional** | `blue`, `indigo`, `navy`, `skyBlue`, `corporateModern` |
| **Nature** | `green`, `emerald`, `teal`, `mint`, `forestGreen` |
| **Warm** | `red`, `rose`, `coral`, `crimson`, `wine` |
| **Creative** | `purple`, `violet`, `lavender`, `techPurple` |
| **Energetic** | `orange`, `amber`, `peach`, `sunsetOrange` |
| **Neutral** | `slate`, `charcoal`, `graphite`, `silver`, `steel` |
| **Special** | `gold`, `bronze`, `copper`, `neonCyan` |
| **Dark** | `amoledBlack`, `midnightBlue`, `carbonDark`, `minimalMono` |

```dart
YoTheme.lightTheme(context, YoColorScheme.techPurple)
YoTheme.darkTheme(context, YoColorScheme.amoledBlack)
```

### Custom Color Scheme

```dart
setCustomPalette(
  light: YoCorePalette(
    text: Color(0xFF1A1A2E),
    background: Color(0xFFFAFAFF),
    primary: Color(0xFF6C63FF),
    secondary: Color(0xFF9D4EDD),
    accent: Color(0xFF00D9A5),
  ),
  dark: YoCorePalette(
    text: Color(0xFFF0F0FF),
    background: Color(0xFF000000),
    primary: Color(0xFF8B7FFF),
    secondary: Color(0xFFB76EFF),
    accent: Color(0xFF1FF8DF),
  ),
);
```

## 🔤 Fonts (51)

```dart
// Font diset sebelum runApp(), bukan di YoTheme
YoTextTheme.setFont(primary: YoFonts.inter)       // Default, clean
YoTextTheme.setFont(primary: YoFonts.poppins)      // Modern
YoTextTheme.setFont(primary: YoFonts.montserrat)   // Elegant
YoTextTheme.setFont(primary: YoFonts.nunito, mono: YoFonts.firaCode)
```

| Kategori | Contoh |
|----------|--------|
| **Sans-Serif** | `inter`, `roboto`, `poppins`, `montserrat`, `openSans`, `nunito`, `lato`, `dmSans` |
| **Serif** | `playfairDisplay`, `merriweather`, `lora`, `notoSerif` |
| **Monospace** | `firaCode`, `jetBrainsMono`, `sourceCodePro`, `robotoMono` |
| **Display** | `oswald`, `bebasNeue`, `anton`, `raleway` |
| **Modern** | `manrope`, `sora`, `lexend`, `outfit`, `plusJakartaSans` |

## 🛠️ Helpers & Utilities

```dart
// Date formatting
YoDateFormatter.formatDate(DateTime.now())       // '07 Dec 2024'
YoDateFormatter.formatRelativeTime(date)         // '2 hours ago'

// ID Generation
YoIdGenerator.uuid()                              // UUID v4
YoIdGenerator.numericId(length: 8)                // '12345678'

// Connectivity
await YoConnectivity.initialize();
bool isOnline = YoConnectivity.isConnected;

// Text Input Formatters
CurrencyTextInputFormatter()          // 1000000 → 1.000.000
IndonesiaCurrencyFormatter()          // 1000000 → Rp 1.000.000
PhoneNumberFormatter()                // 081234567890 → 0812-3456-7890

// Context Extensions
context.screenWidth
context.isSmallScreen   // < 600
context.colorScheme
context.textTheme

// Spacing
YoSpacing.xs  // 4    YoSpacing.sm  // 8
YoSpacing.md  // 16   YoSpacing.lg  // 24
YoSpacing.xl  // 32   YoSpacing.xxl // 48

// Shadow
YoShadow.sm   YoShadow.md   YoShadow.lg   YoShadow.xl
```

## 📖 Dokumentasi Lengkap

| File | Isi |
|------|-----|
| [COMPONENTS.md](COMPONENTS.md) | 80+ widget — parameter, type, default, code example |
| [THEMES.md](THEMES.md) | Color system, 36 scheme, 51 font, shadow |
| [HELPERS.md](HELPERS.md) | Formatter, generator, input formatter, connectivity |
| [CHANGELOG.md](CHANGELOG.md) | Version history v1.0.0 → v0.0.4 |

## 📄 License

MIT License — see [LICENSE](LICENSE)

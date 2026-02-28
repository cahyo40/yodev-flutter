# 🎨 YoUI - Flutter UI Component Library

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.0.5-blue.svg)](CHANGELOG.md)

Library UI Flutter siap produksi dengan **90+ komponen**, **36 color scheme**, **51 font**, dan design system lengkap berbasis token yang konsisten.

## ✨ Highlights

| Fitur | Jumlah |
|-------|--------|
| 🎯 Components | 90+ (Form, Table, Navigation, Chart, Feedback, dll) |
| 🎨 Color Schemes | 36 (Tech, Healthcare, Business, Creative, Dark) |
| 🔤 Google Fonts | 51 (Sans-serif, Serif, Monospace, Display) |
| 📏 Design Tokens | Spacing & Radius System (Sm, Md, Lg, Xl) |
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

### 2. Gunakan Komponen & Tokens

Untuk menjaga konsistensi, hindari penggunaan widget standard Flutter jika sudah ada versi YoUI.

```dart
Column(children: [
  // ✅ Gunakan YoText (Otomatis pakai Design System Typography)
  YoText.headlineMedium('Welcome to YoUI'),
  
  // ✅ Gunakan YoSpace (Otomatis pakai Design System Spacing)
  const YoSpace.height(16), 
  
  YoButton.primary(text: 'Get Started', onPressed: () {}),
  
  const YoSpace.height(24),
  
  // ✅ Gunakan context extension untuk Radius
  Container(
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: context.yoBorderRadiusMd, // Token: 8.0
    ),
    child: YoText.bodyMedium('Adaptive Card'),
  ),
])
```

---

## 📏 Design System Tokens

YoUI menggunakan sistem token untuk **Spacing** dan **Border Radius** guna memastikan konsistensi UI di seluruh aplikasi.

### Border Radius
Akses via `YoSpacing` atau `context` extension:

| Token | Value | Context Getter |
|-------|-------|----------------|
| **Small** | 4.0 | `context.yoRadiusSm` |
| **Medium** | 8.0 | `context.yoRadiusMd` |
| **Large** | 12.0 | `context.yoRadiusLg` |
| **Extra Large** | 16.0 | `context.yoRadiusXl` |

**Usage Example:**
```dart
// Mendapatkan BorderRadius object
borderRadius: context.yoBorderRadiusMd,

// Mendapatkan raw double value
radius: context.yoRadiusLg,
```

### Spacing & Layout
Gunakan `YoSpace` untuk jarak antar widget. Hindari `SizedBox` manual dengan hardcoded value.

```dart
const YoSpace.width(8)   // Small spacing
const YoSpace.height(16) // Medium spacing
const YoSpace.height(24) // Large spacing
```

---

## 🧩 Komponen Utama

### Basic
*   **YoButton**: Primary, Secondary, Outline, Ghost, Modern.
*   **YoCard**: Filled, Elevated, Outlined.
*   **YoFAB**, **YoIconButton**, **YoImage**, **YoDivider**.

### Display
*   **YoText**: Typography system terintegrasi.
*   **YoBadge**, **YoChip**, **YoAvatar**, **YoRating**.
*   **YoProductCard**, **YoArticleCard**, **YoDestinationCard**.
*   **YoCarousel**, **YoDataTable**, **YoTimeline**, **YoKanbanBoard**.

### Form & Input
*   **YoForm**: State management form otomatis.
*   **YoSearchField**, **YoOtpField**, **YoDropdown**.
*   **YoChipInput**, **YoFileUpload**, **YoRangeSlider**.

### Feedback & Overlay
*   **YoLoading**, **YoShimmer**, **YoSkeleton**.
*   **YoToast**, **YoConfirmDialog**, **YoModal**, **YoBottomSheet**.
*   **YoBanner**, **YoProgress**, **YoLoadingOverlay**.

### Navigation
*   **YoAppbar**, **YoBottomNav**, **YoDrawer**, **YoSidebar**.
*   **YoStepper**, **YoPagination**, **YoBreadcrumb**, **YoTabbar**.

---

## 📱 Adaptive & Responsive

Setiap komponen YoUI dirancang untuk adaptif terhadap ukuran layar:

```dart
YoResponsive(
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)

// Atau akses via context
if (context.isTablet) { ... }
final adaptivePadding = context.adaptivePadding;
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

---

## 📖 Dokumentasi Lengkap

| File | Isi |
|------|-----|
| [COMPONENTS.md](COMPONENTS.md) | 80+ widget — parameter, type, default, code example |
| [THEMES.md](THEMES.md) | Color system, 36 scheme, 51 font, shadow |
| [HELPERS.md](HELPERS.md) | Formatter, generator, input formatter, connectivity |
| [CHANGELOG.md](CHANGELOG.md) | History versi & update terbaru |

## 📄 License

MIT License — see [LICENSE](LICENSE)

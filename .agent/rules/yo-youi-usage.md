# YoUI Component Usage Rules

## Prinsip Utama

**SELALU gunakan komponen YoUI, JANGAN gunakan widget Flutter standar** kecuali YoUI tidak menyediakan alternatifnya.

## Mapping Widget

| ❌ Flutter Standar | ✅ YoUI Equivalent |
|-------------------|-------------------|
| `Scaffold` | `YoScaffold` |
| `Text('...')` | `YoText('...')` |
| `Text` untuk heading | `YoText.heading('...')` |
| `ElevatedButton` | `YoButton.primary()` |
| `OutlinedButton` | `YoButton.outline()` |
| `TextButton` | `YoButton.ghost()` |
| `CircularProgressIndicator` | `YoLoading()` |
| `AlertDialog` | `YoConfirmDialog()` |
| `SnackBar` | `YoToast.success/error/info()` |
| `Card` | `YoCard` |
| `Container` + decoration | `YoCard` |
| `Column` + `SizedBox` spacing | `YoColumn(spacing: 16)` |
| `Row` + `SizedBox` spacing | `YoRow(spacing: 8)` |
| `SizedBox(height: 16)` | `YoSpace.md()` |
| `Padding(padding: EdgeInsets.all(16))` | `YoPadding.all()` |
| `GridView` | `YoGrid(columns: 2)` |
| `ListView` shimmer loading | `YoShimmer.listTile()` |
| `showDialog` | `YoDialog.show()` |
| `showModalBottomSheet` | `YoBottomSheet.show()` |
| Manual error widget | `YoErrorState(message:, onRetry:)` |
| Manual empty widget | `YoEmptyState(message:, icon:)` |

## Import

```dart
// Satu import untuk semua YoUI
import 'package:yo_ui/yo_ui.dart';
```

## State Feedback Pattern

Setiap halaman HARUS menangani 4 state:

```dart
// 1. Loading
if (state.isLoading) return const YoLoading();

// 2. Error
if (state.error != null) {
  return YoErrorState(message: state.error!, onRetry: () => refresh());
}

// 3. Empty
if (state.items.isEmpty) {
  return YoEmptyState(message: 'No data', icon: Icons.inbox);
}

// 4. Data
return YoColumn(spacing: 16, children: [...]);
```

## Theme

```dart
// ❌ JANGAN
ThemeData(primarySwatch: Colors.blue)

// ✅ GUNAKAN
YoTheme.light(colorScheme: YoColorScheme.blue, fontFamily: YoFonts.inter)
YoTheme.dark(colorScheme: YoColorScheme.blue, fontFamily: YoFonts.inter)
```

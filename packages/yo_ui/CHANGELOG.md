# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.4] - 2026-01-26

### Added
- **YoAvatar** - New `customSize` parameter for custom pixel sizes
  - Allows any custom pixel size instead of only preset `YoAvatarSize` enum
  - Automatic text/icon/badge size scaling based on custom size
  - Applied to all constructors: default, `.text()`, `.image()`, `.initials()`

### Documentation
- **Complete documentation rewrite** with comprehensive coverage:
  - `COMPONENTS.md` (3,691 lines) - 80+ widgets with full parameters, types, defaults, and code examples
  - `THEMES.md` (1,132 lines) - Color system, 36+ schemes, 51+ fonts, shadows, adaptive layout
  - `HELPERS.md` (1,221 lines) - Formatters, generators, input formatters, connectivity, logger
  - `guide.md` (354 lines) - Quick start overview with navigation links
- Bilingual format (English titles + Indonesian descriptions)
- Parameter tables for every widget with types and default values
- Practical code examples for each component

---

## [0.0.3] - 2026-01-10

### Added
- **YoDialogPicker.monthRange()** - New custom month picker dialog
  - 3x4 month grid (Jan-Dec) without date selection
  - Year navigation with arrows and tap-to-pick year
  - Returns `DateTimeRange` (first to last day of selected month)
  - Themed styling consistent with YoUI design system

### Changed
- **YoMonthPicker** - **BREAKING**: Changed return type from `DateTime` to `DateTimeRange`
  - `selectedDate` → `selectedRange` (`DateTimeRange`)
  - `onMonthChanged` callback now receives `DateTimeRange`
  - Shows custom dialog with month/year only (no date picker)
- **YoIconPicker** - Replaced `TextField` with `YoTextFormField` for search input
- **YoColorPicker** - Replaced `TextField` with `YoTextFormField` for hex color input

### Fixed
- Consistent styling across all picker components

---

## [0.0.2] - 2026-01-09

### Added

#### 🎉 New Components (19 total)

**Form Components (6):**
- `YoForm` - Form validation wrapper with submit handling
- `YoFileUpload` - File upload widget with progress and drag-drop
- `YoSearchField` - Search input with debounce and suggestions dropdown
- `YoOtpField` - OTP/PIN input with auto-focus, paste support, and backspace navigation
- `YoChipInput` - Tag/chip input with suggestions and max limit
- `YoRangeSlider` - Dual-thumb range slider with labels

**Display Components (3):**
- `YoCarousel` - Image slider with auto-play, indicators, and infinite scroll
- `YoDataTable` - Sortable data table with selection and horizontal scroll
- `YoExpansionPanel` - Accordion-style expansion panels (single & list variants)

**Navigation Components (3):**
- `YoPagination` - Page navigation with first/last/prev/next buttons
- `YoStepper` - Multi-step wizard (vertical & horizontal layouts)
- `YoBreadcrumb` - Breadcrumb navigation trail with max items collapse

**Feedback Components (4):**
- `YoShimmer` - Shimmer loading effect with presets (card, listTile, image)
- `YoToast` - Toast notifications (success/error/info/warning variants)
- `YoModal` - Bottom sheet modal with drag handle and custom height
- `YoBanner` - Info banner with dismissible and action button support

**Layout Components (1):**
- `YoMasonryGrid` - Pinterest-style grid with responsive variant

**Utility Components (2):**
- `YoInfiniteScroll` - Lazy loading list with threshold trigger
- `YoFAB.SpeedDial` - Floating action button with expandable menu

#### ✨ Enhanced Shadow System (`YoBoxShadow`)

Added 17+ new shadow variants:
- **State Shadows**: `hover`, `pressed` - Interactive state shadows
- **Special Effects**: `directional`, `neumorphic`, `inner`, `outline` - Design-specific shadows
- **Colored Shadows**: `success`, `error`, `warning`, `info` - Status-based shadows
- **Material Elevations**: `elevation0` through `elevation24` - Material Design levels
- **Size Variants**: `xxl` - Maximum depth shadow

Total shadow options: **26+ variants** with dark/light mode auto-adjustment

### Changed
- Enhanced component documentation with dart doc comments
- Improved type safety across all new components
- Updated shadow system for better consistency

### Fixed
- File picker API compatibility with `YoMultiFilePickerResult`
- `YoButton` variant naming (text → ghost)
- YoStepper button initialization syntax
- Various compilation warnings and type mismatches

---

## [1.1.4] - 2026-01-01

### Added
- **YoButton** - New `borderColor` and `borderColorFollowsText` properties for outline variant
  - Custom border color support (`borderColor` parameter)
  - Option to make border follow text color (`borderColorFollowsText: true`)
  - Default border now uses primary color instead of outline color

- **YoCorePalette** - New card color getters based on primary color
  - `cardColor` - Card background with subtle primary tint
  - `cardBorderColor` - Card border color based on primary
  - `onCard` - Text color for content on cards

- **TextInputFormatters** - Consolidated and expanded formatters
  - `IndonesiaCurrencyFormatter` - Format with Rp prefix (Rp 1.000.000)
  - `IndonesiaPhoneFormatter` - Indonesian phone format (+62/0xxx)
  - `UpperCaseTextFormatter` - Convert input to uppercase
  - `LowerCaseTextFormatter` - Convert input to lowercase

### Changed
- Consolidated `yo_textformfield_formatter.dart` into `yo_text_input_formatters.dart`
- Updated README with Text Input Formatters documentation

### Removed
- Deleted duplicate `yo_textformfield_formatter.dart` file

---

## [1.1.3] - 2025-12-22

### Added
- **YoImagePicker** - Comprehensive image picker utility
  - Pick from camera or gallery
  - Multiple image selection support
  - Video and media picking
  - Source picker dialogs (bottom sheet & dialog)
  - **YoImagePickerConfig** presets: `defaultConfig`, `compressed`, `highQuality`, `thumbnail`, `avatar`
  - **YoImagePickerButton** - Button widget with image preview
  - **YoAvatarPicker** - Circular avatar picker with edit indicator

- **YoFilePicker** - Complete file picker utility
  - Pick any file type (images, videos, audio, documents)
  - Multiple file selection
  - Directory picking (desktop/mobile)
  - Save file dialog
  - **YoFileType** enum: `any`, `media`, `image`, `video`, `audio`, `custom`
  - **YoFileHelper** - File utilities (format size, get icon/color by extension)
  - **YoFilePickerButton** - Button widget with file info display
  - **YoFileDropZone** - Drag & drop zone for file uploads
  - **YoFileListTile** - List tile for displaying picked files

### Dependencies
- Added `image_picker: ^1.1.2` for camera/gallery picking
- Added `file_picker: ^8.1.7` for file system picking

---

## [1.1.2] - 2025-12-22

### Added
- **YoIconPicker** - Comprehensive icon picker component with 200+ categorized Material icons
  - **18 Categories**: Action, Alert, Audio/Video, Communication, Content, Device, Editor, File, Hardware, Home, Image, Maps, Navigation, Notification, Places, Social, Toggle
  - **Search functionality** for quick icon lookup
  - **Category tabs** for organized browsing
  - **Multiple display modes**:
    - Inline widget (`YoIconPicker`)
    - Bottom sheet (`YoIconPicker.showAsBottomSheet()`)
    - Dialog (`YoIconPicker.showAsDialog()`)
  - **YoIconPickerButton** - Button that triggers picker on tap
  - **YoIcons** - Static icon library with category filtering and search
  - **YoIconCategory** enum for icon categorization
  - **YoIconData** model with icon, name, and category

---

## [1.1.1] - 2025-12-22

### Added
- **YoDateRangePicker** - New date range picker component with default and compact layout variants
  - Default layout with single-field date range display
  - Compact layout with separate start/end date fields
  - Integration with `YoDialogPicker.dateRange()`

### Fixed
- Added missing `crypto` package dependency for `YoIdGenerator` hash functions (MD5, SHA1, SHA256)
- Fixed lint issues:
  - Removed deprecated `library yo_ui;` statement (now uses `library;`)
  - Fixed curly braces in flow control structures in `yo_icon_button.dart`
  - Removed unnecessary string interpolation in `yo_chart.dart`
  - Removed unnecessary imports in `yo_skeleton_grid.dart` and `yo_progress.dart`
  - Fixed unnecessary brace in string interpolation in `yo_date_formatter.dart`

### Dependencies
- Added `crypto: ^3.0.6` for hash ID generation

---

## [1.1.0] - 2025-12-07

### Added - New Components
- **Charts** (`YoLineChart`, `YoBarChart`, `YoPieChart`, `YoSparkLine`) - using fl_chart
- **YoProductCard** - E-commerce/POS card with grid, list, and pos variants
- **YoDestinationCard** - Travel app card with default, featured, and compact variants
- **YoProfileCard** - Social app card with default, compact, and cover variants
- **YoArticleCard** - Blog/news card with default, horizontal, and featured variants
- **YoBottomNav** - Animated bottom navigation with badge support
- **YoSidebar** - Collapsible sidebar with expanded/collapsed modes
- **YoDrawerFooter** - Footer widget for drawer

### Added - Color Schemes (6 New)
- **`amoledBlack`** - Pure black AMOLED theme for battery saving
- **`midnightBlue`** - Dark professional theme for enterprise apps
- **`carbonDark`** - Sleek carbon theme for modern dashboards
- **`neonCyberpunk`** - Futuristic neon theme for gaming/tech apps
- **`minimalMono`** - Ultra minimal monochrome theme for focus apps
- **`posRetail`** - Business POS system theme

### Added - Features
- **YoAdaptive** - Comprehensive adaptive design system with breakpoints
- **YoTextTheme.setFont()** - Type-safe font selection using `YoFonts` enum
- **YoFonts enum** - 51 pre-configured Google Fonts for easy selection
- **YoTimeline.stepper()** - Stepper-style timeline factory
- **YoDropDown** - Improved with label, error/helper text, outlined/filled variants
- **Stock indicator** for YoProductCard (for POS systems)
- **Edit/Delete actions** for YoProductCard
- **Dark mode backgrounds** - Changed to pure/near black (#000000) for AMOLED displays

### Improved
- **YoCalendar** - Simplified from 927 to ~420 lines, removed YoCalendarTheme
- **YoKanbanBoard** - Added didUpdateWidget sync, removed duplicate YoKanbanBoardSimple
- **YoComment** - Simplified from 805 to ~280 lines
- **YoChatBubble** - Cleaner code with switch expressions
- **YoDrawer** - Added divider/header items, SafeArea wrapper
- **YoTimeline** - Added isCompleted/isActive states, alternating layout
- **YoEmptyState** - Merged YoErrorState functionality
- **YoDialog** - Simplified with static methods (info, success, error, warning)
- **YoConfirmDialog** - Added showDestructive, showWithIcon methods
- **YoBottomSheet** - Added showList helper, fixed Expanded error
- **YoSnackBar** - Added shortcut methods (success, error, warning, info)
- **YoAvatar** - Added border support, simplified with static maps
- **YoChip** - Added preset variants (success, error, warning, info)

### Fixed
- Replaced all deprecated `withOpacity()` with `withAlpha()`
- Replaced deprecated `textScaleFactor` with `textScaler.scale()`
- Fixed doc comments with unintended HTML (`<T>` → `` `T` ``)
- Fixed recursive build issues in dialogs
- Removed duplicate responsive code (consolidated to YoAdaptive)
- Fixed `YoDeviceHelper` screen size checks

### Deprecated
- `YoResponsive` - Use `YoAdaptive` instead
- Old responsive extensions in `context_extension.dart` and `device_extensions.dart`
- `YoTextTheme.setFontFamily()` - Use `YoTextTheme.setFont()` with `YoFonts` enum instead

### Dependencies
- Added `fl_chart: ^0.69.2` for chart components

---

## [1.0.3+1] - 2025-12-07

### Fixed
- Fixed `onBackground` getter in `YoCorePalette` - now correctly uses `background.computeLuminance()` instead of `primary.computeLuminance()`

## [1.0.3] - 2025-12-01

### Added
- 30 industry-specific color schemes with light/dark mode support
- Comprehensive component library with 60+ widgets
- Responsive design utilities (`YoResponsive`)
- Form components with validation support
- Picker components (Date, Time, DateTime)
- Skeleton loading components
- Kanban board widget
- Timeline widget
- Chat bubble component

### Changed
- Updated to Material 3 design system
- Improved theme customization options

## [1.0.2] - 2025-11-15

### Added
- `YoConnectivity` for network state management
- `YoLogger` for development debugging
- `YoIdGenerator` for various ID generation patterns
- `YoDateFormatter` with relative time support
- `YoCurrencyFormatter` for Indonesian Rupiah

### Improved
- Button variants (primary, secondary, outline, ghost, neumorphism)
- Card elevation options
- Image caching with `cached_network_image`

## [1.0.1] - 2025-10-20

### Added
- Context extensions for easy access to theme styles
- `YoPadding` and `YoSpacing` utility classes
- `YoShadow` for consistent elevation styles
- `YoEmptyState` and `YoErrorState` feedback widgets

### Fixed
- Theme color consistency across components

## [1.0.0] - 2025-10-01

### Added
- Initial release
- Core components (YoText, YoButton, YoCard)
- Theme system with light & dark mode
- Color palette system with `YoColors`
- Typography system with `YoTextTheme`
- Basic layout components (YoColumn, YoRow, YoGrid)
- Navigation components (YoAppBar, YoBottomBar, YoDrawer, YoTabBar)
- Feedback components (YoLoading, YoDialog, YoBottomSheet, YoSnackbar)
- Image handling (YoImage, YoImageViewer)
- Device helper utilities

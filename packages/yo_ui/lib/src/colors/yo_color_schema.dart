import 'package:flutter/material.dart';

import '../../yo_ui.dart';

enum YoColorScheme {
  // CORE CATEGORIES - Updated with harmonious colors
  defaultScheme, // Finance & Banking - Classic Blue
  techPurple, // Technology & SaaS - Modern Purple
  oceanTeal, // Healthcare & Medical - Clean Teal
  energyRed, // Social Media & Entertainment - Vibrant Red
  educationIndigo, // Education & E-learning - Trustworthy Indigo
  productivityGreen, // Productivity & Task Management - Fresh Green
  creativeMagenta, // Creative & Design - Artistic Magenta
  wellnessMint, // Wellness & Meditation - Calm Mint
  retailClay, // E-commerce & Retail - Warm Clay
  travelCoral, // Travel & Hospitality - Adventure Coral
  // LIFESTYLE & SPECIALIZED
  foodAmber, // Food & Beverage - Appetizing Amber
  romanticRose, // Wedding & Events - Romantic Rose
  natureEvergreen, // Environment & Sustainability - Natural Green
  corporateModern, // Enterprise & B2B - Professional
  startupVibrant, // Startup & Innovation - Energetic
  luxuryMinimal, // Luxury & Premium - Elegant
  fitnessEnergy, // Fitness & Sports - Motivational
  musicVibes, // Music & Streaming - Creative
  // MODERN CATEGORIES
  codingDark, // Developer Tools - Focus Dark
  kidsLearning, // Kids Apps - Playful
  realEstatePro, // Real Estate - Trustworthy
  cryptoModern, // Cryptocurrency - Modern
  newsMagazine, // News & Media - Professional
  scienceLab, // Science - Precise
  // DARK THEMES
  amoledBlack, // Pure Black AMOLED - Battery Saving
  midnightBlue, // Midnight Blue - Dark Professional
  carbonDark, // Carbon Dark - Sleek & Modern
  posRetail, // POS & Retail - Business Focused
  // NEW INDUSTRY SCHEMES
  sportsDynamic, // Sports Teams & Stadiums - Dynamic
  financeSecure, // Banking & Finance - Trust & Wealth
  legalPro, // Legal & Law - Professional
  automotiveSpeed, // Automotive & Racing - Speed
  petFriendly, // Pet Care & Veterinary - Warm & Playful
  groceryFresh, // Grocery & Food Delivery - Fresh & Natural

  custom,
}

YoCorePalette? _customLight;
YoCorePalette? _customDark;

void setCustomPalette({
  required YoCorePalette light,
  required YoCorePalette dark,
}) {
  _customLight = light;
  _customDark = dark;
}

// Pure black for AMOLED dark mode
const Color _pureBlack = Color(0xFF000000);

const Color _deepBlack = Color(0xFF0A0A0A);

final Map<YoColorScheme, Map<Brightness, YoCorePalette>> kYoPalettes = {
  // 1. DEFAULT - Finance & Banking (Trust & Stability)
  YoColorScheme.defaultScheme: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1A365D),
      background: Color(0xFFF7FAFC),
      primary: Color(0xFF2D3748),
      secondary: Color(0xFF4A5568),
      accent: Color(0xFF3182CE),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF7FAFC),
      background: _deepBlack,
      primary: Color(0xFFE2E8F0),
      secondary: Color(0xFFCBD5E0),
      accent: Color(0xFF63B3ED),
    ),
  },

  // 2. TECH PURPLE - Technology & SaaS (Innovation)
  YoColorScheme.techPurple: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1A1A2E),
      background: Color(0xFFF8F9FF),
      primary: Color(0xFF5B4CFF),
      secondary: Color(0xFF8C82FF),
      accent: Color(0xFF00D4AA),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFE6E6FA),
      background: _pureBlack,
      primary: Color(0xFF7C6FFF),
      secondary: Color(0xFFA49BFF),
      accent: Color(0xFF1FF8DF),
    ),
  },

  // 3. OCEAN TEAL - Healthcare & Medical (Clean & Trust)
  YoColorScheme.oceanTeal: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF002B2B),
      background: Color(0xFFF0FFFE),
      primary: Color(0xFF008080),
      secondary: Color(0xFF4ECDC4),
      accent: Color(0xFFFF6B6B),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFE6FFFE),
      background: _pureBlack,
      primary: Color(0xFF00A3A3),
      secondary: Color(0xFF5DE5DC),
      accent: Color(0xFFFF8A7A),
    ),
  },

  // 4. ENERGY RED - Social Media & Entertainment (Energetic)
  YoColorScheme.energyRed: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF2B0008),
      background: Color(0xFFFFF5F7),
      primary: Color(0xFFE4002B),
      secondary: Color(0xFFFF7B9C),
      accent: Color(0xFF00C0CC),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFFE6EB),
      background: _pureBlack,
      primary: Color(0xFFFF1A47),
      secondary: Color(0xFFFF8FB0),
      accent: Color(0xFF00E5FF),
    ),
  },

  // 5. EDUCATION INDIGO - Education & E-learning (Trust & Focus)
  YoColorScheme.educationIndigo: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF0F111A),
      background: Color(0xFFF7F8FD),
      primary: Color(0xFF3F4C8A),
      secondary: Color(0xFF6B76C4),
      accent: Color(0xFFF9C24E),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF0F2FF),
      background: _pureBlack,
      primary: Color(0xFF5A6ABF),
      secondary: Color(0xFF8A94E4),
      accent: Color(0xFFFFD166),
    ),
  },

  // 6. PRODUCTIVITY GREEN - Productivity & Tasks (Fresh & Positive)
  YoColorScheme.productivityGreen: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1A2E05),
      background: Color(0xFFF7FEE7),
      primary: Color(0xFF65A30D),
      secondary: Color(0xFF84CC16),
      accent: Color(0xFFFF6B35),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF7FEE7),
      background: _pureBlack,
      primary: Color(0xFF84CC16),
      secondary: Color(0xFFA3E635),
      accent: Color(0xFFFF8555),
    ),
  },

  // 7. CREATIVE MAGENTA - Creative & Design (Artistic)
  YoColorScheme.creativeMagenta: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF0B0B28),
      background: Color(0xFFFAFAFF),
      primary: Color(0xFFD5007F),
      secondary: Color(0xFF8B5CF6),
      accent: Color(0xFF00E5C9),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF0F0FF),
      background: _pureBlack,
      primary: Color(0xFFFF0984),
      secondary: Color(0xFFA855F7),
      accent: Color(0xFF1FF8DF),
    ),
  },

  // 8. WELLNESS MINT - Wellness & Meditation (Calm)
  YoColorScheme.wellnessMint: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF002E1F),
      background: Color(0xFFF0FFFA),
      primary: Color(0xFF00B894),
      secondary: Color(0xFF55EFC4),
      accent: Color(0xFFFD79A8),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFE6FFF7),
      background: _pureBlack,
      primary: Color(0xFF00D9A0),
      secondary: Color(0xFF73FFD2),
      accent: Color(0xFFFF9BC0),
    ),
  },

  // 9. RETAIL CLAY - E-commerce & Retail (Warm & Trustworthy)
  YoColorScheme.retailClay: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF2A1E13),
      background: Color(0xFFFDF8F2),
      primary: Color(0xFFA06A46),
      secondary: Color(0xFFD8A070),
      accent: Color(0xFF5E9E7F),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFDF2E6),
      background: _deepBlack,
      primary: Color(0xFFC0875C),
      secondary: Color(0xFFE8B880),
      accent: Color(0xFF7BC097),
    ),
  },

  // 10. TRAVEL CORAL - Travel & Hospitality (Adventure)
  YoColorScheme.travelCoral: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF001F3F),
      background: Color(0xFFF5F9FF),
      primary: Color(0xFFFF6F61),
      secondary: Color(0xFF003366),
      accent: Color(0xFFFFD166),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFE6F2FF),
      background: _pureBlack,
      primary: Color(0xFFFF8A7A),
      secondary: Color(0xFF004C8C),
      accent: Color(0xFFFFE18A),
    ),
  },

  // 11. FOOD AMBER - Food & Beverage (Appetizing)
  YoColorScheme.foodAmber: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF78350F),
      background: Color(0xFFFFFBEB),
      primary: Color(0xFFD97706),
      secondary: Color(0xFFF59E0B),
      accent: Color(0xFFDC2626),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFEF3C7),
      background: _deepBlack,
      primary: Color(0xFFF59E0B),
      secondary: Color(0xFFFBBF24),
      accent: Color(0xFFEF4444),
    ),
  },

  // 12. ROMANTIC ROSE - Wedding & Events (Elegant)
  YoColorScheme.romanticRose: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF701A75),
      background: Color(0xFFFDF4FF),
      primary: Color(0xFFDB2777),
      secondary: Color(0xFFE879F9),
      accent: Color(0xFFF59E0B),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFAE8FF),
      background: _pureBlack,
      primary: Color(0xFFF472B6),
      secondary: Color(0xFFF0ABFF),
      accent: Color(0xFFFBBF24),
    ),
  },

  // 13. NATURE EVERGREEN - Environment & Sustainability (Natural)
  YoColorScheme.natureEvergreen: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF064E3B),
      background: Color(0xFFF0FDF4),
      primary: Color(0xFF059669),
      secondary: Color(0xFF10B981),
      accent: Color(0xFFD97706),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFECFDF5),
      background: _pureBlack,
      primary: Color(0xFF10B981),
      secondary: Color(0xFF34D399),
      accent: Color(0xFFF59E0B),
    ),
  },

  // 14. CORPORATE MODERN - Enterprise & B2B (Professional)
  YoColorScheme.corporateModern: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1F2937),
      background: Color(0xFFF9FAFB),
      primary: Color(0xFF374151),
      secondary: Color(0xFF6B7280),
      accent: Color(0xFF059669),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF9FAFB),
      background: _deepBlack,
      primary: Color(0xFFD1D5DB),
      secondary: Color(0xFF9CA3AF),
      accent: Color(0xFF10B981),
    ),
  },

  // 15. STARTUP VIBRANT - Startup & Innovation (Energetic)
  YoColorScheme.startupVibrant: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1A0B2E),
      background: Color(0xFFF8FAFC),
      primary: Color(0xFF8B5CF6),
      secondary: Color(0xFFEC4899),
      accent: Color(0xFF06B6D4),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFAF5FF),
      background: _pureBlack,
      primary: Color(0xFFA855F7),
      secondary: Color(0xFFF472B6),
      accent: Color(0xFF22D3EE),
    ),
  },

  // 16. LUXURY MINIMAL - Luxury & Premium (Elegant)
  YoColorScheme.luxuryMinimal: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF000000),
      background: Color(0xFFFFFFFF),
      primary: Color(0xFF000000),
      secondary: Color(0xFF666666),
      accent: Color(0xFFCA8A04),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFFFFFF),
      background: _pureBlack,
      primary: Color(0xFFFFFFFF),
      secondary: Color(0xFFCCCCCC),
      accent: Color(0xFFEAB308),
    ),
  },

  // 17. FITNESS ENERGY - Fitness & Sports (Motivational)
  YoColorScheme.fitnessEnergy: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF7F1D1D),
      background: Color(0xFFFEF2F2),
      primary: Color(0xFFDC2626),
      secondary: Color(0xFFEA580C),
      accent: Color(0xFF059669),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFECACA),
      background: _pureBlack,
      primary: Color(0xFFEF4444),
      secondary: Color(0xFFF97316),
      accent: Color(0xFF10B981),
    ),
  },

  // 19. MUSIC VIBES - Music & Streaming (Creative)
  YoColorScheme.musicVibes: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF581C87),
      background: Color(0xFFFDF4FF),
      primary: Color(0xFFA855F7),
      secondary: Color(0xFFEC4899),
      accent: Color(0xFF06B6D4),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF5D0FE),
      background: _pureBlack,
      primary: Color(0xFFC084FC),
      secondary: Color(0xFFF472B6),
      accent: Color(0xFF22D3EE),
    ),
  },

  // 20. CODING DARK - Developer Tools (Focus)
  YoColorScheme.codingDark: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF111827),
      background: Color(0xFFF9FAFB),
      primary: Color(0xFF2563EB),
      secondary: Color(0xFF374151),
      accent: Color(0xFF059669),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF3F4F6),
      background: _pureBlack,
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF4B5563),
      accent: Color(0xFF10B981),
    ),
  },

  // 21. KIDS LEARNING - Kids Apps (Playful)
  YoColorScheme.kidsLearning: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF701A75),
      background: Color(0xFFFDF4FF),
      primary: Color(0xFFEC4899),
      secondary: Color(0xFF8B5CF6),
      accent: Color(0xFF06B6D4),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFAF5FF),
      background: _deepBlack,
      primary: Color(0xFFF472B6),
      secondary: Color(0xFFA855F7),
      accent: Color(0xFF22D3EE),
    ),
  },

  // 24. REAL ESTATE PRO - Real Estate (Trustworthy)
  YoColorScheme.realEstatePro: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1F2937),
      background: Color(0xFFF8FAFC),
      primary: Color(0xFF0369A1),
      secondary: Color(0xFF059669),
      accent: Color(0xFFD97706),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF9FAFB),
      background: _pureBlack,
      primary: Color(0xFF0EA5E9),
      secondary: Color(0xFF10B981),
      accent: Color(0xFFF59E0B),
    ),
  },

  // 25. CRYPTO MODERN - Cryptocurrency (Modern)
  YoColorScheme.cryptoModern: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1F2937),
      background: Color(0xFFFFFBEB),
      primary: Color(0xFFF59E0B),
      secondary: Color(0xFFEF4444),
      accent: Color(0xFF10B981),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFEF3C7),
      background: _pureBlack,
      primary: Color(0xFFFBBF24),
      secondary: Color(0xFFF87171),
      accent: Color(0xFF34D399),
    ),
  },

  // 26. NEWS MAGAZINE - News & Media (Professional)
  YoColorScheme.newsMagazine: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1F2937),
      background: Color(0xFFFFFFFF),
      primary: Color(0xFF000000),
      secondary: Color(0xFF6B7280),
      accent: Color(0xFFDC2626),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF9FAFB),
      background: _pureBlack,
      primary: Color(0xFFFFFFFF),
      secondary: Color(0xFF9CA3AF),
      accent: Color(0xFFEF4444),
    ),
  },

  // 27. SCIENCE LAB - Science & Research (Precise)
  YoColorScheme.scienceLab: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1F2937),
      background: Color(0xFFF8FAFC),
      primary: Color(0xFF7C3AED),
      secondary: Color(0xFF06B6D4),
      accent: Color(0xFFEC4899),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF9FAFB),
      background: _pureBlack,
      primary: Color(0xFF8B5CF6),
      secondary: Color(0xFF22D3EE),
      accent: Color(0xFFF472B6),
    ),
  },

  // ============ DARK THEMES ============

  // 28. AMOLED BLACK - Pure Black for AMOLED displays (Battery Saving)
  YoColorScheme.amoledBlack: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1F2937),
      background: Color(0xFFF9FAFB),
      primary: Color(0xFF6366F1),
      secondary: Color(0xFF8B5CF6),
      accent: Color(0xFF06B6D4),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFFFFFF),
      background: _pureBlack,
      primary: Color(0xFF818CF8),
      secondary: Color(0xFFA78BFA),
      accent: Color(0xFF22D3EE),
    ),
  },

  // 32. MIDNIGHT BLUE - Dark Professional (Enterprise Apps)
  YoColorScheme.midnightBlue: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1E3A5F),
      background: Color(0xFFF0F4F8),
      primary: Color(0xFF1E40AF),
      secondary: Color(0xFF3B82F6),
      accent: Color(0xFF10B981),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFE0E7FF),
      background: _pureBlack,
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF60A5FA),
      accent: Color(0xFF34D399),
    ),
  },

  // 33. CARBON DARK - Sleek Carbon (Modern Dashboard)
  YoColorScheme.carbonDark: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF18181B),
      background: Color(0xFFFAFAFA),
      primary: Color(0xFF27272A),
      secondary: Color(0xFF52525B),
      accent: Color(0xFFF97316),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFAFAFA),
      background: _pureBlack,
      primary: Color(0xFFE4E4E7),
      secondary: Color(0xFFA1A1AA),
      accent: Color(0xFFFB923C),
    ),
  },

  // 31. POS RETAIL - Business POS System (Retail Focus)
  YoColorScheme.posRetail: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1F2937),
      background: Color(0xFFF3F4F6),
      primary: Color(0xFF4F46E5),
      secondary: Color(0xFF059669),
      accent: Color(0xFFDC2626),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFF9FAFB),
      background: _pureBlack,
      primary: Color(0xFF6366F1),
      secondary: Color(0xFF10B981),
      accent: Color(0xFFEF4444),
    ),
  },

  // ============ NEW INDUSTRY SCHEMES ============

  // 32. SPORTS DYNAMIC - Sports Teams & Stadiums (Dynamic)
  YoColorScheme.sportsDynamic: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1E3A8A),
      background: Color(0xFFF8FAFC),
      primary: Color(0xFF2563EB),
      secondary: Color(0xFF1D4ED8),
      accent: Color(0xFFEF4444),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFE0E7FF),
      background: _pureBlack,
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF60A5FA),
      accent: Color(0xFFF87171),
    ),
  },

  // 33. FINANCE SECURE - Banking & Finance (Trust & Wealth)
  YoColorScheme.financeSecure: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF115E59),
      background: Color(0xFFF0FDFA),
      primary: Color(0xFF0D9488),
      secondary: Color(0xFF14B8A6),
      accent: Color(0xFFF59E0B),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFCCFBF1),
      background: _pureBlack,
      primary: Color(0xFF14B8A6),
      secondary: Color(0xFF2DD4BF),
      accent: Color(0xFFFBBF24),
    ),
  },

  // 34. LEGAL PRO - Legal & Law (Professional)
  YoColorScheme.legalPro: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF1E3A5F),
      background: Color(0xFFF8FAFC),
      primary: Color(0xFF1E3A5F),
      secondary: Color(0xFF334155),
      accent: Color(0xFFCA8A04),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFE2E8F0),
      background: _pureBlack,
      primary: Color(0xFF475569),
      secondary: Color(0xFF64748B),
      accent: Color(0xFFEAB308),
    ),
  },

  // 35. AUTOMOTIVE SPEED - Automotive & Racing (Speed)
  YoColorScheme.automotiveSpeed: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF18181B),
      background: Color(0xFFFAFAFA),
      primary: Color(0xFFDC2626),
      secondary: Color(0xFF27272A),
      accent: Color(0xFFF59E0B),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFFAFAFA),
      background: _pureBlack,
      primary: Color(0xFFEF4444),
      secondary: Color(0xFF52525B),
      accent: Color(0xFFFBBF24),
    ),
  },

  // 36. PET FRIENDLY - Pet Care & Veterinary (Warm & Playful)
  YoColorScheme.petFriendly: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF065F46),
      background: Color(0xFFF0FDF4),
      primary: Color(0xFF10B981),
      secondary: Color(0xFF34D399),
      accent: Color(0xFFF472B6),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFECFDF5),
      background: _pureBlack,
      primary: Color(0xFF34D399),
      secondary: Color(0xFF6EE7B7),
      accent: Color(0xFFF9A8D4),
    ),
  },

  // 37. GROCERY FRESH - Grocery & Food Delivery (Fresh & Natural)
  YoColorScheme.groceryFresh: {
    Brightness.light: const YoCorePalette(
      text: Color(0xFF166534),
      background: Color(0xFFF7FEE7),
      primary: Color(0xFF22C55E),
      secondary: Color(0xFF4ADE80),
      accent: Color(0xFFFB923C),
    ),
    Brightness.dark: const YoCorePalette(
      text: Color(0xFFDCFCE7),
      background: _pureBlack,
      primary: Color(0xFF4ADE80),
      secondary: Color(0xFF86EFAC),
      accent: Color(0xFFFDBA74),
    ),
  },

  // CUSTOM
  YoColorScheme.custom: {
    Brightness.light: _customLight ??
        const YoCorePalette(
          text: Color(0xFF000000),
          background: Color(0xFFFFFFFF),
          primary: Color(0xFF6200EE),
          secondary: Color(0xFF03DAC6),
          accent: Color(0xFF018786),
        ),
    Brightness.dark: _customDark ??
        const YoCorePalette(
          text: Color(0xFFFFFFFF),
          background: _pureBlack,
          primary: Color(0xFFBB86FC),
          secondary: Color(0xFF03DAC6),
          accent: Color(0xFF03DAC6),
        ),
  },
};

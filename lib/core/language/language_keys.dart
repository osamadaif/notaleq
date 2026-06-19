/// Translation key constants. Every user-facing string is looked up through
/// these (`context.tr(LangKeys.total)`), never hard-coded, so the `ar` / `en`
/// JSON bundles stay the single source of copy.
class LangKeys {
  LangKeys._();

  // Brand
  static const String appName = 'app_name';
  static const String developerName = 'developer_name';
  static const String developedBy = 'developed_by';
  static const String appTagline = 'app_tagline';

  // Calculator / ledger
  static const String draft = 'draft';
  static const String total = 'total';
  static const String newLine = 'new_line';
  static const String excluded = 'excluded';
  static const String noComment = 'no_comment';
  static const String commentHint = 'comment_hint';
  static const String linesCount = 'lines_count'; // "{count} lines"
  static const String comingSoon = 'coming_soon';
  static const String needsOperatorFirst = 'needs_operator_first';

  // Actions
  static const String save = 'save';
  static const String cancel = 'cancel';
  static const String delete = 'delete';
  static const String clearAll = 'clear_all';

  // Save sheet
  static const String saveSheet = 'save_sheet';
  static const String sheetNameHint = 'sheet_name_hint';
  static const String saveNeedsAmount = 'save_needs_amount';

  // History
  static const String history = 'history';
  static const String searchHint = 'search_hint';

  // AC confirmation
  static const String clearAllTitle = 'clear_all_title';
  static const String clearAllBody = 'clear_all_body';

  // Settings
  static const String settings = 'settings';
  static const String language = 'language';
  static const String clickSound = 'click_sound';
  static const String haptics = 'haptics';
  static const String decimalPlaces = 'decimal_places';
  static const String currency = 'currency';
  static const String currencyNone = 'currency_none';
  static const String themeMode = 'theme_mode';
  static const String themeLight = 'theme_light';
  static const String themeDark = 'theme_dark';
  static const String themeSystem = 'theme_system';
  static const String about = 'about';

  // Empty states
  static const String emptyDraftTitle = 'empty_draft_title';
  static const String emptyDraftBody = 'empty_draft_body';
  static const String emptyHistoryTitle = 'empty_history_title';
  static const String emptyHistoryBody = 'empty_history_body';
}

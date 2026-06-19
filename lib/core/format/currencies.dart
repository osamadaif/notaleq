/// Supported currencies. Only the ISO codes live in code; every **name** and
/// **symbol** is localised in `assets/translations/*.json` (keys
/// `currency_<code>` and `currency_<code>_symbol`) — never hard-coded copy.
///
/// The set covers the currencies of the app's supported languages (USD, EUR,
/// GBP, CNY, INR) plus the major Arab economies (EGP, SAR, AED, KWD, QAR).
class Currencies {
  Currencies._();

  /// ISO codes in display order. A `null` selection means "no currency".
  static const List<String> codes = [
    'EGP',
    'SAR',
    'AED',
    'KWD',
    'QAR',
    'USD',
    'EUR',
    'GBP',
    'CNY',
    'INR',
  ];

  /// Translation key for a currency's full name (e.g. `currency_egp`).
  static String nameKey(String code) => 'currency_${code.toLowerCase()}';

  /// Translation key for a currency's display symbol (e.g. `currency_egp_symbol`).
  static String symbolKey(String code) =>
      'currency_${code.toLowerCase()}_symbol';
}

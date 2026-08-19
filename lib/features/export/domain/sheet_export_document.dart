import 'package:decimal/decimal.dart';

import '../../../core/database/app_database.dart';
import '../../../core/format/ledger_amount_formatter.dart';
import '../../calculator/domain/entities/ledger_line.dart';

enum SheetExportFormat { image, pdf }

class SheetExportIdentity {
  const SheetExportIdentity({
    required this.brand,
    required this.title,
    required this.dateText,
    required this.isRtl,
  });

  final String brand;
  final String title;
  final String dateText;
  final bool isRtl;
}

class SheetExportSummary {
  const SheetExportSummary({
    required this.lineCountText,
    required this.totalText,
    this.currency,
  });

  final String lineCountText;
  final String totalText;
  final String? currency;
}

class SheetExportLabels {
  const SheetExportLabels({
    required this.operation,
    required this.details,
    required this.total,
    required this.subtotal,
    required this.excluded,
    required this.page,
    required this.createdWith,
  });

  final String operation;
  final String details;
  final String total;
  final String subtotal;
  final String excluded;
  final String page;
  final String createdWith;
}

class SheetExportRequest {
  const SheetExportRequest({
    required this.identity,
    required this.summary,
    required this.labels,
    required this.decimalPlaces,
  });

  final SheetExportIdentity identity;
  final SheetExportSummary summary;
  final SheetExportLabels labels;
  final int decimalPlaces;
}

sealed class SheetExportRow {
  const SheetExportRow();
}

class SheetExportEntry extends SheetExportRow {
  const SheetExportEntry({
    required this.number,
    required this.amount,
    required this.details,
    required this.isNegative,
    required this.isError,
  });

  final int number;
  final String amount;
  final String details;
  final bool isNegative;
  final bool isError;
}

class SheetExportSection extends SheetExportRow {
  const SheetExportSection(this.title);

  final String title;
}

class SheetExportSubtotal extends SheetExportRow {
  const SheetExportSubtotal(this.label, this.amount);

  final String label;
  final String amount;
}

class SheetExportDocument {
  const SheetExportDocument({
    required this.identity,
    required this.summary,
    required this.labels,
    required this.rows,
  });

  static const LedgerAmountFormatter _ledgerAmounts = LedgerAmountFormatter();

  final SheetExportIdentity identity;
  final SheetExportSummary summary;
  final SheetExportLabels labels;
  final List<SheetExportRow> rows;

  factory SheetExportDocument.fromLedger(
    List<LedgerLine> lines,
    SheetExportRequest request,
  ) => SheetExportDocument(
    identity: request.identity,
    summary: request.summary,
    labels: request.labels,
    rows: _ledgerRows(lines, request),
  );

  factory SheetExportDocument.fromStored(
    List<Line> lines,
    SheetExportRequest request,
  ) => SheetExportDocument(
    identity: request.identity,
    summary: request.summary,
    labels: request.labels,
    rows: _storedRows(lines, request),
  );

  static List<SheetExportRow> _ledgerRows(
    List<LedgerLine> lines,
    SheetExportRequest request,
  ) {
    var entryNumber = 0;
    final rows = <SheetExportRow>[];
    for (final line in lines) {
      if (line.isBlank) continue;
      if (line.isSubtotal) {
        rows.add(_subtotal(line.computedValue, request));
      } else if (line.isSectionHeader) {
        rows.add(SheetExportSection(line.comment!.trim()));
      } else if (line.hasExpression) {
        entryNumber += 1;
        rows.add(_ledgerEntry(line, entryNumber, request));
      }
    }
    return rows;
  }

  static List<SheetExportRow> _storedRows(
    List<Line> lines,
    SheetExportRequest request,
  ) {
    var entryNumber = 0;
    final rows = <SheetExportRow>[];
    for (final line in lines) {
      if (line.entryType == LedgerLineKind.subtotal.name) {
        rows.add(_subtotal(_decimal(line.computedValue), request));
      } else if (_isStoredSection(line)) {
        rows.add(SheetExportSection(line.comment!.trim()));
      } else if (line.rawExpression.trim().isNotEmpty) {
        entryNumber += 1;
        rows.add(_storedEntry(line, entryNumber, request));
      }
    }
    return rows;
  }

  static SheetExportEntry _ledgerEntry(
    LedgerLine line,
    int number,
    SheetExportRequest request,
  ) {
    final display = _ledgerAmounts.format(
      rawExpression: line.rawExpression,
      computedAmount: line.computedValue,
      isError: line.isError,
      decimalPlaces: request.decimalPlaces,
    );
    return SheetExportEntry(
      number: number,
      amount: display.text,
      details: line.comment?.trim() ?? '',
      isNegative: display.isNegative,
      isError: line.isError,
    );
  }

  static SheetExportEntry _storedEntry(
    Line line,
    int number,
    SheetExportRequest request,
  ) {
    final display = _ledgerAmounts.format(
      rawExpression: line.rawExpression,
      computedAmount: _decimal(line.computedValue),
      isError: line.isError == 1,
      decimalPlaces: request.decimalPlaces,
    );
    return SheetExportEntry(
      number: number,
      amount: display.text,
      details: line.comment?.trim() ?? '',
      isNegative: display.isNegative,
      isError: line.isError == 1,
    );
  }

  static SheetExportSubtotal _subtotal(
    Decimal subtotal,
    SheetExportRequest request,
  ) {
    final display = _ledgerAmounts.format(
      rawExpression: '',
      computedAmount: subtotal,
      isError: false,
      decimalPlaces: request.decimalPlaces,
    );
    return SheetExportSubtotal(request.labels.subtotal, display.text);
  }

  static bool _isStoredSection(Line line) =>
      line.rawExpression.trim().isEmpty &&
      (line.comment?.trim().isNotEmpty ?? false);

  static Decimal _decimal(String raw) => Decimal.tryParse(raw) ?? Decimal.zero;
}

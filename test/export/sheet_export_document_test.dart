import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/core/database/app_database.dart';
import 'package:notaleq/features/calculator/domain/entities/ledger_line.dart';
import 'package:notaleq/features/export/domain/sheet_export_document.dart';

void main() {
  SheetExportRequest request() => const SheetExportRequest(
    identity: SheetExportIdentity(
      brand: 'نوتاليك',
      title: 'مصاريف الشهر',
      dateText: '2026/08/19 | 12:00',
      isRtl: true,
    ),
    summary: SheetExportSummary(
      lineCountText: '3 سطر',
      totalText: '150',
      currency: 'ج.م',
    ),
    labels: SheetExportLabels(
      operation: 'العملية',
      details: 'التفاصيل',
      total: 'الإجمالي',
      subtotal: 'المجموع الفرعي',
      excluded: 'مُستبعد',
      page: 'صفحة',
      createdWith: 'أُنشئ بواسطة',
    ),
    decimalPlaces: 2,
  );

  test('ledger export keeps sections, subtotals, errors, and numbering', () {
    final sheet = SheetExportDocument.fromLedger([
      LedgerLine.empty(),
      LedgerLine(comment: 'الأساسيات', computedValue: Decimal.zero),
      LedgerLine(
        rawExpression: '100',
        comment: 'إيجار',
        computedValue: Decimal.parse('100'),
      ),
      LedgerLine.subtotal(Decimal.parse('100')),
      LedgerLine(rawExpression: '+50', computedValue: Decimal.parse('50')),
      LedgerLine(
        rawExpression: '+1/0',
        computedValue: Decimal.zero,
        isError: true,
      ),
    ], request());

    expect(sheet.rows, hasLength(5));
    expect((sheet.rows[0] as SheetExportSection).title, 'الأساسيات');
    expect((sheet.rows[1] as SheetExportEntry).number, 1);
    expect((sheet.rows[1] as SheetExportEntry).details, 'إيجار');
    expect((sheet.rows[2] as SheetExportSubtotal).amount, '100');
    expect((sheet.rows[3] as SheetExportEntry).number, 2);
    expect((sheet.rows[3] as SheetExportEntry).amount, '+50');
    expect((sheet.rows[4] as SheetExportEntry).number, 3);
    expect((sheet.rows[4] as SheetExportEntry).isError, isTrue);
    expect((sheet.rows[4] as SheetExportEntry).amount, '+1÷0');
  });

  test('stored export maps persisted row types without losing comments', () {
    final sheet = SheetExportDocument.fromStored([
      const Line(
        id: 1,
        calculationId: 1,
        position: 0,
        entryType: 'expression',
        rawExpression: '200',
        computedValue: '200',
        comment: 'دخل',
        isError: 0,
      ),
      const Line(
        id: 2,
        calculationId: 1,
        position: 1,
        entryType: 'subtotal',
        rawExpression: '',
        computedValue: '200',
        isError: 0,
      ),
    ], request());

    expect(sheet.rows, hasLength(2));
    expect((sheet.rows.first as SheetExportEntry).details, 'دخل');
    expect(sheet.rows.last, isA<SheetExportSubtotal>());
  });
}

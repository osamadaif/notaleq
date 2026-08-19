import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/features/export/data/sheet_export_pdf_builder.dart';
import 'package:notaleq/features/export/domain/sheet_export_document.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a long Arabic ledger builds as a multi-page PDF', () async {
    final rows = <SheetExportRow>[
      const SheetExportSection('المصروفات الأساسية'),
      for (var index = 1; index <= 120; index++)
        SheetExportEntry(
          number: index,
          amount: index.isEven ? '−1,250.5' : '+750',
          details: 'تفاصيل العملية رقم $index مع تعليق واضح',
          isNegative: index.isEven,
          isError: index % 19 == 0,
        ),
      const SheetExportSubtotal('المجموع الفرعي', '−30,030'),
    ];
    final sheet = SheetExportDocument(
      identity: const SheetExportIdentity(
        brand: 'نوتاليك',
        title: 'مصاريف المشروع الطويلة',
        dateText: '2026/08/19 | 12:00',
        isRtl: true,
      ),
      summary: const SheetExportSummary(
        lineCountText: '120 سطر',
        totalText: '−30,030',
        currency: 'ر.س',
      ),
      labels: const SheetExportLabels(
        operation: 'العملية',
        details: 'التفاصيل',
        total: 'الإجمالي',
        subtotal: 'المجموع الفرعي',
        excluded: 'مُستبعد',
        page: 'صفحة',
        createdWith: 'أُنشئ بواسطة',
      ),
      rows: rows,
    );

    final bytes = await const SheetExportPdfBuilder().build(sheet);
    final source = latin1.decode(bytes, allowInvalid: true);

    expect(source, startsWith('%PDF-'));
    expect(
      RegExp(r'/Type\s*/Page\b').allMatches(source).length,
      greaterThan(1),
    );
  });
}

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/sheet_export_document.dart';

class SheetExportPdfBuilder {
  const SheetExportPdfBuilder();

  Future<Uint8List> build(SheetExportDocument sheet) async {
    final fonts = await _loadFonts();
    final logo = await _loadLogo();
    final pdf = pw.Document(
      title: sheet.identity.title,
      creator: sheet.identity.brand,
      producer: sheet.identity.brand,
    );
    pdf.addPage(
      pw.MultiPage(
        pageTheme: _pageTheme(sheet, fonts),
        maxPages: math.max(20, sheet.rows.length + 4),
        header: (context) => _pageHeader(sheet, fonts, logo),
        footer: (context) => _pageFooter(context, sheet, fonts),
        build: (context) => _content(sheet, fonts),
      ),
    );
    return pdf.save();
  }

  pw.PageTheme _pageTheme(SheetExportDocument sheet, _SheetPdfFonts fonts) {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(38, 26, 38, 28),
      textDirection: _direction(sheet),
      theme: _fontTheme(fonts),
      buildBackground: (_) => _pageBackground(),
    );
  }

  pw.ThemeData _fontTheme(_SheetPdfFonts fonts) => pw.ThemeData.withFont(
    base: fonts.arabicRegular,
    bold: fonts.arabicBold,
    fontFallback: [fonts.monoRegular],
  );

  pw.Widget _pageBackground() => pw.FullPage(
    ignoreMargins: true,
    child: pw.Container(color: _appBackground),
  );

  pw.Widget _pageHeader(
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
    pw.MemoryImage logo,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 15),
      child: pw.Directionality(
        textDirection: pw.TextDirection.ltr,
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _exportDate(sheet, fonts),
            pw.Spacer(),
            _brandLockup(sheet, fonts, logo),
          ],
        ),
      ),
    );
  }

  Future<_SheetPdfFonts> _loadFonts() async {
    return _SheetPdfFonts(
      arabicRegular: await _loadFont(
        'assets/fonts/IBMPlexSansArabic-Regular.ttf',
      ),
      arabicBold: await _loadFont(
        'assets/fonts/IBMPlexSansArabic-SemiBold.ttf',
      ),
      monoRegular: await _loadFont('assets/fonts/IBMPlexMono-Regular.ttf'),
      monoBold: await _loadFont('assets/fonts/IBMPlexMono-SemiBold.ttf'),
    );
  }

  Future<pw.Font> _loadFont(String asset) async =>
      pw.Font.ttf(await rootBundle.load(asset));

  Future<pw.MemoryImage> _loadLogo() async {
    final bytes = await rootBundle.load(
      'app-icon-exports/mark-1024-transparent.png',
    );
    return pw.MemoryImage(bytes.buffer.asUint8List());
  }

  List<pw.Widget> _content(SheetExportDocument sheet, _SheetPdfFonts fonts) => [
    _titleCard(sheet, fonts),
    pw.SizedBox(height: 18),
    _ledgerTable(sheet, fonts),
    pw.SizedBox(height: 18),
    _grandTotal(sheet, fonts),
  ];

  pw.Widget _exportDate(SheetExportDocument sheet, _SheetPdfFonts fonts) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 6),
      child: pw.Text(
        sheet.identity.dateText,
        textDirection: pw.TextDirection.ltr,
        style: _monoRegular(fonts, 10.5, _textMuted),
      ),
    );
  }

  pw.Widget _brandLockup(
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
    pw.MemoryImage logo,
  ) {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Image(logo, width: 52, height: 52, fit: pw.BoxFit.contain),
        pw.SizedBox(height: 2),
        pw.Text(
          sheet.identity.brand,
          textDirection: _direction(sheet),
          style: _arabicBold(fonts, 10.5, _accentStrong),
        ),
      ],
    );
  }

  pw.Widget _pageFooter(
    pw.Context context,
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 14),
      child: pw.Directionality(
        textDirection: pw.TextDirection.ltr,
        child: pw.Row(
          children: [
            pw.Text(
              '${sheet.labels.createdWith} ${sheet.identity.brand}',
              textDirection: _direction(sheet),
              style: _arabicRegular(fonts, 9.5, _textMuted),
            ),
            pw.Spacer(),
            _pageNumber(context, sheet, fonts),
          ],
        ),
      ),
    );
  }

  pw.Widget _pageNumber(
    pw.Context context,
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
  ) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          '${context.pageNumber}/${context.pagesCount}',
          style: _monoRegular(fonts, 9.5, _textMuted),
        ),
        pw.SizedBox(width: 4),
        pw.Text(
          sheet.labels.page,
          textDirection: _direction(sheet),
          style: _arabicRegular(fonts, 9.5, _textMuted),
        ),
      ],
    );
  }

  pw.Widget _titleCard(SheetExportDocument sheet, _SheetPdfFonts fonts) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: _accentStrong,
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  sheet.identity.title,
                  style: _arabicBold(fonts, 25, PdfColors.white),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  sheet.summary.lineCountText,
                  style: _arabicRegular(fonts, 12, _accentSoft),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 16),
          pw.Container(
            width: 88,
            height: 44,
            decoration: pw.BoxDecoration(
              color: _accent,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Center(
              child: pw.Text(
                sheet.identity.brand,
                style: _arabicBold(fonts, 15, PdfColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _ledgerTable(SheetExportDocument sheet, _SheetPdfFonts fonts) {
    return pw.Table(
      border: const pw.TableBorder(
        top: pw.BorderSide(color: _tableDivider, width: 0.8),
        bottom: pw.BorderSide(color: _tableDivider, width: 0.8),
        left: pw.BorderSide(color: _tableDivider, width: 0.8),
        right: pw.BorderSide(color: _tableDivider, width: 0.8),
        horizontalInside: pw.BorderSide(color: _hairline, width: 0.65),
        verticalInside: pw.BorderSide(color: _tableDivider, width: 0.8),
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(3.2),
        1: pw.FlexColumnWidth(6.0),
        2: pw.FlexColumnWidth(1.0),
      },
      children: [
        _tableHeader(sheet, fonts),
        for (final row in sheet.rows) _tableRow(row, sheet, fonts),
      ],
    );
  }

  pw.TableRow _tableHeader(SheetExportDocument sheet, _SheetPdfFonts fonts) {
    return pw.TableRow(
      repeat: true,
      decoration: const pw.BoxDecoration(color: _accentStrong),
      verticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        _headerCell(sheet.labels.operation, fonts, pw.TextAlign.left),
        _headerCell(sheet.labels.details, fonts, _textAlign(sheet)),
        _headerCell('#', fonts, pw.TextAlign.center),
      ],
    );
  }

  pw.TableRow _tableRow(
    SheetExportRow row,
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
  ) {
    return switch (row) {
      SheetExportEntry() => _entryRow(row, sheet, fonts),
      SheetExportSection() => _sectionRow(row, sheet, fonts),
      SheetExportSubtotal() => _subtotalRow(row, sheet, fonts),
    };
  }

  pw.TableRow _entryRow(
    SheetExportEntry row,
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
  ) {
    final details = row.isError
        ? _errorDetails(row.details, sheet.labels.excluded)
        : row.details;
    final amountColor = row.isError
        ? _error
        : row.isNegative
        ? _negative
        : _textPrimary;
    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: row.isError
            ? _errorSoft
            : row.number.isEven
            ? _rowAlternate
            : PdfColors.white,
      ),
      verticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        _amountCell(row.amount, fonts, amountColor),
        _detailsCell(details, sheet, fonts, row.isError ? _error : null),
        _numberCell(row.number, fonts),
      ],
    );
  }

  pw.TableRow _sectionRow(
    SheetExportSection row,
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
  ) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: _surfaceSunken),
      verticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        _amountCell('', fonts, _textPrimary),
        _boldDetailsCell(row.title, sheet, fonts, _accentStrong),
        _numberCell(null, fonts),
      ],
    );
  }

  pw.TableRow _subtotalRow(
    SheetExportSubtotal row,
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
  ) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: _accentSoft),
      verticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        _boldAmountCell(row.amount, fonts, _accentStrong),
        _boldDetailsCell(row.label, sheet, fonts, _accentStrong),
        _numberCell(null, fonts),
      ],
    );
  }

  pw.Widget _grandTotal(SheetExportDocument sheet, _SheetPdfFonts fonts) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: pw.BoxDecoration(
        color: _accentSoft,
        border: pw.Border.all(color: _accent, width: 0.8),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Row(
        children: [
          _grandTotalAmount(sheet, fonts),
          pw.Spacer(),
          pw.Text(
            sheet.labels.total,
            style: _arabicBold(fonts, 15, _accentStrong),
          ),
        ],
      ),
    );
  }

  pw.Widget _grandTotalAmount(SheetExportDocument sheet, _SheetPdfFonts fonts) {
    final amount = pw.Text(
      sheet.summary.totalText,
      textDirection: pw.TextDirection.ltr,
      style: _monoBold(fonts, 22, _accentStrong),
    );
    final currency = sheet.summary.currency;
    if (currency == null || currency.isEmpty) return amount;
    return pw.Directionality(
      textDirection: pw.TextDirection.ltr,
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          amount,
          pw.SizedBox(width: 7),
          pw.Text(
            currency,
            textDirection: _direction(sheet),
            style: _arabicBold(fonts, 13, _accentStrong),
          ),
        ],
      ),
    );
  }

  pw.Widget _headerCell(String text, _SheetPdfFonts fonts, pw.TextAlign align) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 11, vertical: 11),
      child: pw.Text(
        text,
        textAlign: align,
        style: _arabicBold(fonts, 11.5, PdfColors.white),
      ),
    );
  }

  pw.Widget _amountCell(String text, _SheetPdfFonts fonts, PdfColor color) =>
      _amountCellWithFont(text, fonts, color, fonts.monoRegular);

  pw.Widget _boldAmountCell(
    String text,
    _SheetPdfFonts fonts,
    PdfColor color,
  ) => _amountCellWithFont(text, fonts, color, fonts.monoBold);

  pw.Widget _amountCellWithFont(
    String text,
    _SheetPdfFonts fonts,
    PdfColor color,
    pw.Font numberFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 11, vertical: 13),
      child: pw.RichText(
        textAlign: pw.TextAlign.left,
        textDirection: pw.TextDirection.ltr,
        text: pw.TextSpan(
          children: _amountSpans(text, fonts, color, numberFont),
        ),
      ),
    );
  }

  List<pw.InlineSpan> _amountSpans(
    String text,
    _SheetPdfFonts fonts,
    PdfColor color,
    pw.Font numberFont,
  ) {
    return [
      for (final match in _amountTokenPattern.allMatches(text))
        pw.TextSpan(
          text: _operatorGlyphs.contains(match[0])
              ? '${match.start == 0 ? '' : ' '}${match[0]}  '
              : match[0],
          style: _operatorGlyphs.contains(match[0])
              ? _monoBold(fonts, 15.5, _accent)
              : _textStyle(numberFont, fonts.arabicRegular, 14, color),
        ),
    ];
  }

  pw.Widget _detailsCell(
    String text,
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
    PdfColor? color,
  ) => _detailsCellWithStyle(
    text,
    sheet,
    _arabicRegular(fonts, 12.5, color ?? _textSecondary),
  );

  pw.Widget _boldDetailsCell(
    String text,
    SheetExportDocument sheet,
    _SheetPdfFonts fonts,
    PdfColor color,
  ) => _detailsCellWithStyle(text, sheet, _arabicBold(fonts, 12.5, color));

  pw.Widget _detailsCellWithStyle(
    String text,
    SheetExportDocument sheet,
    pw.TextStyle style,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 11, vertical: 13),
      child: pw.Text(
        text,
        textAlign: _textAlign(sheet),
        textDirection: _direction(sheet),
        style: style,
      ),
    );
  }

  pw.Widget _numberCell(int? number, _SheetPdfFonts fonts) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 13),
      child: pw.Text(
        number?.toString() ?? '',
        textAlign: pw.TextAlign.center,
        style: _monoRegular(fonts, 10.5, _textMuted),
      ),
    );
  }

  String _errorDetails(String details, String excluded) =>
      details.isEmpty ? excluded : '$details ($excluded)';

  pw.TextDirection _direction(SheetExportDocument sheet) =>
      sheet.identity.isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;

  pw.TextAlign _textAlign(SheetExportDocument sheet) =>
      sheet.identity.isRtl ? pw.TextAlign.right : pw.TextAlign.left;

  pw.TextStyle _arabicRegular(
    _SheetPdfFonts fonts,
    double size,
    PdfColor color,
  ) => _textStyle(fonts.arabicRegular, fonts.monoRegular, size, color);

  pw.TextStyle _arabicBold(_SheetPdfFonts fonts, double size, PdfColor color) =>
      _textStyle(fonts.arabicBold, fonts.monoRegular, size, color);

  pw.TextStyle _monoRegular(
    _SheetPdfFonts fonts,
    double size,
    PdfColor color,
  ) => _textStyle(fonts.monoRegular, fonts.arabicRegular, size, color);

  pw.TextStyle _monoBold(_SheetPdfFonts fonts, double size, PdfColor color) =>
      _textStyle(fonts.monoBold, fonts.arabicRegular, size, color);

  pw.TextStyle _textStyle(
    pw.Font font,
    pw.Font fallback,
    double size,
    PdfColor color,
  ) {
    return pw.TextStyle(
      font: font,
      fontFallback: [fallback],
      fontSize: size,
      color: color,
    );
  }

  static const PdfColor _accent = PdfColor.fromInt(0xFF0E7A6B);
  static const PdfColor _accentStrong = PdfColor.fromInt(0xFF0A5347);
  static const PdfColor _accentSoft = PdfColor.fromInt(0xFFE3F1EE);
  static const PdfColor _appBackground = PdfColor.fromInt(0xFFF4F6F5);
  static const PdfColor _surfaceSunken = PdfColor.fromInt(0xFFEAEEEC);
  static const PdfColor _rowAlternate = PdfColor.fromInt(0xFFF8FAF9);
  static const PdfColor _hairline = PdfColor.fromInt(0xFFE0E6E3);
  static const PdfColor _tableDivider = PdfColor.fromInt(0xFFC9D5D1);
  static const PdfColor _textPrimary = PdfColor.fromInt(0xFF14201D);
  static const PdfColor _textSecondary = PdfColor.fromInt(0xFF52605C);
  static const PdfColor _textMuted = PdfColor.fromInt(0xFF8A968F);
  static const PdfColor _error = PdfColor.fromInt(0xFFC8472F);
  static const PdfColor _errorSoft = PdfColor.fromInt(0xFFFBEAE6);
  static const PdfColor _negative = PdfColor.fromInt(0xFFA2604F);
  static const Set<String> _operatorGlyphs = {'+', '−', '×', '÷'};
  static final RegExp _amountTokenPattern = RegExp(r'[+−×÷]|[^+−×÷]+');
}

class _SheetPdfFonts {
  const _SheetPdfFonts({
    required this.arabicRegular,
    required this.arabicBold,
    required this.monoRegular,
    required this.monoBold,
  });

  final pw.Font arabicRegular;
  final pw.Font arabicBold;
  final pw.Font monoRegular;
  final pw.Font monoBold;
}

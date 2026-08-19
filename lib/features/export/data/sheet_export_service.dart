import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Rect;

import 'package:flutter/services.dart' show PlatformException;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' show TooManyPagesException;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/sheet_export_document.dart';
import 'sheet_export_pdf_builder.dart';

class SheetExportException implements Exception {
  const SheetExportException(this.cause);

  final Object cause;
}

class SheetExportService {
  const SheetExportService();

  static const SheetExportPdfBuilder _pdfBuilder = SheetExportPdfBuilder();

  Future<void> share(
    SheetExportDocument sheet,
    Rect origin,
    SheetExportFormat format,
  ) => switch (format) {
    SheetExportFormat.image => shareImages(sheet, origin),
    SheetExportFormat.pdf => sharePdf(sheet, origin),
  };

  Future<void> sharePdf(SheetExportDocument sheet, Rect origin) async {
    final pdfBytes = await _buildPdf(sheet);
    final fileStem = _fileStem(sheet.identity.title);
    final pdfFile = await _writeFile('$fileStem.pdf', pdfBytes);
    await _shareFiles(
      [XFile(pdfFile.path, mimeType: 'application/pdf')],
      sheet,
      origin,
    );
  }

  Future<void> shareImages(SheetExportDocument sheet, Rect origin) async {
    final pdfBytes = await _buildPdf(sheet);
    final fileStem = _fileStem(sheet.identity.title);
    final imageFiles = await _rasterizePages(pdfBytes, fileStem);
    await _shareFiles(imageFiles, sheet, origin);
  }

  Future<Uint8List> _buildPdf(SheetExportDocument sheet) async {
    try {
      return await _pdfBuilder.build(sheet);
    } on TooManyPagesException catch (error) {
      throw SheetExportException(error);
    }
  }

  Future<List<XFile>> _rasterizePages(
    Uint8List pdfBytes,
    String fileStem,
  ) async {
    try {
      await _ensureRasterAvailable();
      final images = <XFile>[];
      var pageNumber = 0;
      await for (final page in Printing.raster(pdfBytes, dpi: 144)) {
        pageNumber += 1;
        images.add(await _writeImagePage(page, fileStem, pageNumber));
      }
      if (images.isEmpty) {
        throw SheetExportException(StateError('No image pages were created'));
      }
      return images;
    } on SheetExportException {
      rethrow;
    } on PlatformException catch (error) {
      throw SheetExportException(error);
    } on UnsupportedError catch (error) {
      throw SheetExportException(error);
    } on Exception catch (error) {
      throw SheetExportException(error);
    }
  }

  Future<void> _ensureRasterAvailable() async {
    final capabilities = await Printing.info();
    if (!capabilities.canRaster) {
      throw const SheetExportException('PDF rasterization is unavailable');
    }
  }

  Future<XFile> _writeImagePage(
    PdfRaster page,
    String fileStem,
    int pageNumber,
  ) async {
    final suffix = pageNumber.toString().padLeft(2, '0');
    final file = await _writeFile('$fileStem-$suffix.png', await page.toPng());
    return XFile(file.path, mimeType: 'image/png');
  }

  Future<File> _writeFile(String name, Uint8List bytes) async {
    try {
      final tempDirectory = await getTemporaryDirectory();
      final exportDirectory = Directory(
        p.join(tempDirectory.path, 'notaleq_exports'),
      );
      await exportDirectory.create(recursive: true);
      return File(
        p.join(exportDirectory.path, name),
      ).writeAsBytes(bytes, flush: true);
    } on FileSystemException catch (error) {
      throw SheetExportException(error);
    } on MissingPlatformDirectoryException catch (error) {
      throw SheetExportException(error);
    }
  }

  Future<void> _shareFiles(
    List<XFile> files,
    SheetExportDocument sheet,
    Rect origin,
  ) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: files,
          title: sheet.identity.title,
          subject: sheet.identity.title,
          sharePositionOrigin: origin,
        ),
      );
    } on PlatformException catch (error) {
      throw SheetExportException(error);
    } on UnsupportedError catch (error) {
      throw SheetExportException(error);
    } on Exception catch (error) {
      throw SheetExportException(error);
    }
  }

  String _fileStem(String title) {
    final safeTitle = title
        .replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1F]'), '-')
        .trim();
    final base = safeTitle.isEmpty ? 'notaleq-sheet' : safeTitle;
    final shortened = String.fromCharCodes(base.runes.take(60));
    return '$shortened-'
        '${DateTime.now().millisecondsSinceEpoch}';
  }
}

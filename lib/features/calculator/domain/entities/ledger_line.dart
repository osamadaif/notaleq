import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../parser/expression_evaluator.dart';

part 'ledger_line.freezed.dart';

/// How a line joins the running result of the lines above it (tape model).
/// A leading `× / ÷` multiplies/divides the running total; everything else
/// (a bare number or a leading `+ / −` sign) is added as a signed value.
enum LedgerJoin { add, mul, div }

/// One row of the ledger as the editor sees it (a non-DB domain entity).
///
/// Built from a raw expression by the cubit via [ExpressionEvaluator]; persisted
/// by the repository into the drift `lines` table. The [join] is derived from
/// the leading operator of [rawExpression] (so the DB needs no extra column),
/// and [computedValue] is the line's operand: the signed value for [LedgerJoin.add],
/// or the magnitude for [LedgerJoin.mul] / [LedgerJoin.div].
@freezed
sealed class LedgerLine with _$LedgerLine {
  const LedgerLine._();

  const factory LedgerLine({
    @Default('') String rawExpression,
    String? comment,
    @Default(LedgerJoin.add) LedgerJoin join,
    required Decimal computedValue,
    @Default(false) bool isError,
    ExpressionErrorKind? errorKind,
  }) = _LedgerLine;

  /// An empty value line (created from a blank draft row).
  factory LedgerLine.empty() => LedgerLine(computedValue: Decimal.zero);

  bool get hasExpression => rawExpression.trim().isNotEmpty;

  bool get hasComment => comment?.trim().isNotEmpty ?? false;

  /// Comment-only line → acts as a section header, contributes nothing.
  bool get isSectionHeader => !hasExpression && hasComment;

  /// Completely empty (no expression, no comment).
  bool get isBlank => !hasExpression && !hasComment;

  /// Only valid value lines feed the running total.
  bool get countsTowardTotal => hasExpression && !isError;

  /// A real, user-visible error (red) vs. a still-incomplete line while typing.
  bool get isHardError =>
      isError &&
      errorKind != ExpressionErrorKind.empty &&
      errorKind != ExpressionErrorKind.incomplete;
}

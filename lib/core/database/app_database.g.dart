// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CalculationsTable extends Calculations
    with TableInfo<$CalculationsTable, Calculation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalculationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDraftMeta = const VerificationMeta(
    'isDraft',
  );
  @override
  late final GeneratedColumn<int> isDraft = GeneratedColumn<int>(
    'is_draft',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _cachedTotalMeta = const VerificationMeta(
    'cachedTotal',
  );
  @override
  late final GeneratedColumn<String> cachedTotal = GeneratedColumn<String>(
    'cached_total',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('0'),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isDraft,
    cachedTotal,
    currencyCode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calculations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Calculation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('is_draft')) {
      context.handle(
        _isDraftMeta,
        isDraft.isAcceptableOrUnknown(data['is_draft']!, _isDraftMeta),
      );
    }
    if (data.containsKey('cached_total')) {
      context.handle(
        _cachedTotalMeta,
        cachedTotal.isAcceptableOrUnknown(
          data['cached_total']!,
          _cachedTotalMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Calculation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Calculation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      isDraft: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_draft'],
      )!,
      cachedTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cached_total'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CalculationsTable createAlias(String alias) {
    return $CalculationsTable(attachedDatabase, alias);
  }
}

class Calculation extends DataClass implements Insertable<Calculation> {
  final int id;

  /// User-chosen name. NULL while it's an unsaved draft.
  final String? name;

  /// 1 = the active working sheet; 0 = a saved sheet (history).
  final int isDraft;

  /// Last computed total as a decimal string (cached for history listing).
  final String cachedTotal;

  /// Optional ISO code (e.g. 'EGP'). NULL = no currency. Reserved for future.
  final String? currencyCode;

  /// Epoch millis (UTC).
  final int createdAt;
  final int updatedAt;
  const Calculation({
    required this.id,
    this.name,
    required this.isDraft,
    required this.cachedTotal,
    this.currencyCode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['is_draft'] = Variable<int>(isDraft);
    map['cached_total'] = Variable<String>(cachedTotal);
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CalculationsCompanion toCompanion(bool nullToAbsent) {
    return CalculationsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      isDraft: Value(isDraft),
      cachedTotal: Value(cachedTotal),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Calculation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Calculation(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      isDraft: serializer.fromJson<int>(json['isDraft']),
      cachedTotal: serializer.fromJson<String>(json['cachedTotal']),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'isDraft': serializer.toJson<int>(isDraft),
      'cachedTotal': serializer.toJson<String>(cachedTotal),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Calculation copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    int? isDraft,
    String? cachedTotal,
    Value<String?> currencyCode = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => Calculation(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    isDraft: isDraft ?? this.isDraft,
    cachedTotal: cachedTotal ?? this.cachedTotal,
    currencyCode: currencyCode.present ? currencyCode.value : this.currencyCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Calculation copyWithCompanion(CalculationsCompanion data) {
    return Calculation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isDraft: data.isDraft.present ? data.isDraft.value : this.isDraft,
      cachedTotal: data.cachedTotal.present
          ? data.cachedTotal.value
          : this.cachedTotal,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Calculation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDraft: $isDraft, ')
          ..write('cachedTotal: $cachedTotal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    isDraft,
    cachedTotal,
    currencyCode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Calculation &&
          other.id == this.id &&
          other.name == this.name &&
          other.isDraft == this.isDraft &&
          other.cachedTotal == this.cachedTotal &&
          other.currencyCode == this.currencyCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CalculationsCompanion extends UpdateCompanion<Calculation> {
  final Value<int> id;
  final Value<String?> name;
  final Value<int> isDraft;
  final Value<String> cachedTotal;
  final Value<String?> currencyCode;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const CalculationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.cachedTotal = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CalculationsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.cachedTotal = const Value.absent(),
    this.currencyCode = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  }) : createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Calculation> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? isDraft,
    Expression<String>? cachedTotal,
    Expression<String>? currencyCode,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isDraft != null) 'is_draft': isDraft,
      if (cachedTotal != null) 'cached_total': cachedTotal,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CalculationsCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<int>? isDraft,
    Value<String>? cachedTotal,
    Value<String?>? currencyCode,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return CalculationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isDraft: isDraft ?? this.isDraft,
      cachedTotal: cachedTotal ?? this.cachedTotal,
      currencyCode: currencyCode ?? this.currencyCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isDraft.present) {
      map['is_draft'] = Variable<int>(isDraft.value);
    }
    if (cachedTotal.present) {
      map['cached_total'] = Variable<String>(cachedTotal.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalculationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isDraft: $isDraft, ')
          ..write('cachedTotal: $cachedTotal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LinesTable extends Lines with TableInfo<$LinesTable, Line> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _calculationIdMeta = const VerificationMeta(
    'calculationId',
  );
  @override
  late final GeneratedColumn<int> calculationId = GeneratedColumn<int>(
    'calculation_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calculations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawExpressionMeta = const VerificationMeta(
    'rawExpression',
  );
  @override
  late final GeneratedColumn<String> rawExpression = GeneratedColumn<String>(
    'raw_expression',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _computedValueMeta = const VerificationMeta(
    'computedValue',
  );
  @override
  late final GeneratedColumn<String> computedValue = GeneratedColumn<String>(
    'computed_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('0'),
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isErrorMeta = const VerificationMeta(
    'isError',
  );
  @override
  late final GeneratedColumn<int> isError = GeneratedColumn<int>(
    'is_error',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    calculationId,
    position,
    rawExpression,
    computedValue,
    comment,
    isError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Line> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('calculation_id')) {
      context.handle(
        _calculationIdMeta,
        calculationId.isAcceptableOrUnknown(
          data['calculation_id']!,
          _calculationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calculationIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('raw_expression')) {
      context.handle(
        _rawExpressionMeta,
        rawExpression.isAcceptableOrUnknown(
          data['raw_expression']!,
          _rawExpressionMeta,
        ),
      );
    }
    if (data.containsKey('computed_value')) {
      context.handle(
        _computedValueMeta,
        computedValue.isAcceptableOrUnknown(
          data['computed_value']!,
          _computedValueMeta,
        ),
      );
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
      );
    }
    if (data.containsKey('is_error')) {
      context.handle(
        _isErrorMeta,
        isError.isAcceptableOrUnknown(data['is_error']!, _isErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Line map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Line(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      calculationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calculation_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      rawExpression: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_expression'],
      )!,
      computedValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}computed_value'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      isError: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_error'],
      )!,
    );
  }

  @override
  $LinesTable createAlias(String alias) {
    return $LinesTable(attachedDatabase, alias);
  }
}

class Line extends DataClass implements Insertable<Line> {
  final int id;
  final int calculationId;

  /// 0-based order within the sheet.
  final int position;

  /// Exact tokens the user typed, e.g. "100+200*3". Source of truth.
  final String rawExpression;

  /// Evaluated signed result as a decimal string.
  final String computedValue;

  /// Optional note. May be NULL/empty; a comment-only line is a section header.
  final String? comment;

  /// 1 = invalid / incomplete / divide-by-zero. Excluded from the total.
  final int isError;
  const Line({
    required this.id,
    required this.calculationId,
    required this.position,
    required this.rawExpression,
    required this.computedValue,
    this.comment,
    required this.isError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['calculation_id'] = Variable<int>(calculationId);
    map['position'] = Variable<int>(position);
    map['raw_expression'] = Variable<String>(rawExpression);
    map['computed_value'] = Variable<String>(computedValue);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['is_error'] = Variable<int>(isError);
    return map;
  }

  LinesCompanion toCompanion(bool nullToAbsent) {
    return LinesCompanion(
      id: Value(id),
      calculationId: Value(calculationId),
      position: Value(position),
      rawExpression: Value(rawExpression),
      computedValue: Value(computedValue),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      isError: Value(isError),
    );
  }

  factory Line.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Line(
      id: serializer.fromJson<int>(json['id']),
      calculationId: serializer.fromJson<int>(json['calculationId']),
      position: serializer.fromJson<int>(json['position']),
      rawExpression: serializer.fromJson<String>(json['rawExpression']),
      computedValue: serializer.fromJson<String>(json['computedValue']),
      comment: serializer.fromJson<String?>(json['comment']),
      isError: serializer.fromJson<int>(json['isError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'calculationId': serializer.toJson<int>(calculationId),
      'position': serializer.toJson<int>(position),
      'rawExpression': serializer.toJson<String>(rawExpression),
      'computedValue': serializer.toJson<String>(computedValue),
      'comment': serializer.toJson<String?>(comment),
      'isError': serializer.toJson<int>(isError),
    };
  }

  Line copyWith({
    int? id,
    int? calculationId,
    int? position,
    String? rawExpression,
    String? computedValue,
    Value<String?> comment = const Value.absent(),
    int? isError,
  }) => Line(
    id: id ?? this.id,
    calculationId: calculationId ?? this.calculationId,
    position: position ?? this.position,
    rawExpression: rawExpression ?? this.rawExpression,
    computedValue: computedValue ?? this.computedValue,
    comment: comment.present ? comment.value : this.comment,
    isError: isError ?? this.isError,
  );
  Line copyWithCompanion(LinesCompanion data) {
    return Line(
      id: data.id.present ? data.id.value : this.id,
      calculationId: data.calculationId.present
          ? data.calculationId.value
          : this.calculationId,
      position: data.position.present ? data.position.value : this.position,
      rawExpression: data.rawExpression.present
          ? data.rawExpression.value
          : this.rawExpression,
      computedValue: data.computedValue.present
          ? data.computedValue.value
          : this.computedValue,
      comment: data.comment.present ? data.comment.value : this.comment,
      isError: data.isError.present ? data.isError.value : this.isError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Line(')
          ..write('id: $id, ')
          ..write('calculationId: $calculationId, ')
          ..write('position: $position, ')
          ..write('rawExpression: $rawExpression, ')
          ..write('computedValue: $computedValue, ')
          ..write('comment: $comment, ')
          ..write('isError: $isError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    calculationId,
    position,
    rawExpression,
    computedValue,
    comment,
    isError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Line &&
          other.id == this.id &&
          other.calculationId == this.calculationId &&
          other.position == this.position &&
          other.rawExpression == this.rawExpression &&
          other.computedValue == this.computedValue &&
          other.comment == this.comment &&
          other.isError == this.isError);
}

class LinesCompanion extends UpdateCompanion<Line> {
  final Value<int> id;
  final Value<int> calculationId;
  final Value<int> position;
  final Value<String> rawExpression;
  final Value<String> computedValue;
  final Value<String?> comment;
  final Value<int> isError;
  const LinesCompanion({
    this.id = const Value.absent(),
    this.calculationId = const Value.absent(),
    this.position = const Value.absent(),
    this.rawExpression = const Value.absent(),
    this.computedValue = const Value.absent(),
    this.comment = const Value.absent(),
    this.isError = const Value.absent(),
  });
  LinesCompanion.insert({
    this.id = const Value.absent(),
    required int calculationId,
    required int position,
    this.rawExpression = const Value.absent(),
    this.computedValue = const Value.absent(),
    this.comment = const Value.absent(),
    this.isError = const Value.absent(),
  }) : calculationId = Value(calculationId),
       position = Value(position);
  static Insertable<Line> custom({
    Expression<int>? id,
    Expression<int>? calculationId,
    Expression<int>? position,
    Expression<String>? rawExpression,
    Expression<String>? computedValue,
    Expression<String>? comment,
    Expression<int>? isError,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calculationId != null) 'calculation_id': calculationId,
      if (position != null) 'position': position,
      if (rawExpression != null) 'raw_expression': rawExpression,
      if (computedValue != null) 'computed_value': computedValue,
      if (comment != null) 'comment': comment,
      if (isError != null) 'is_error': isError,
    });
  }

  LinesCompanion copyWith({
    Value<int>? id,
    Value<int>? calculationId,
    Value<int>? position,
    Value<String>? rawExpression,
    Value<String>? computedValue,
    Value<String?>? comment,
    Value<int>? isError,
  }) {
    return LinesCompanion(
      id: id ?? this.id,
      calculationId: calculationId ?? this.calculationId,
      position: position ?? this.position,
      rawExpression: rawExpression ?? this.rawExpression,
      computedValue: computedValue ?? this.computedValue,
      comment: comment ?? this.comment,
      isError: isError ?? this.isError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (calculationId.present) {
      map['calculation_id'] = Variable<int>(calculationId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rawExpression.present) {
      map['raw_expression'] = Variable<String>(rawExpression.value);
    }
    if (computedValue.present) {
      map['computed_value'] = Variable<String>(computedValue.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (isError.present) {
      map['is_error'] = Variable<int>(isError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LinesCompanion(')
          ..write('id: $id, ')
          ..write('calculationId: $calculationId, ')
          ..write('position: $position, ')
          ..write('rawExpression: $rawExpression, ')
          ..write('computedValue: $computedValue, ')
          ..write('comment: $comment, ')
          ..write('isError: $isError')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CalculationsTable calculations = $CalculationsTable(this);
  late final $LinesTable lines = $LinesTable(this);
  late final CalculationsDao calculationsDao = CalculationsDao(
    this as AppDatabase,
  );
  late final LinesDao linesDao = LinesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [calculations, lines];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'calculations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lines', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CalculationsTableCreateCompanionBuilder =
    CalculationsCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<int> isDraft,
      Value<String> cachedTotal,
      Value<String?> currencyCode,
      required int createdAt,
      required int updatedAt,
    });
typedef $$CalculationsTableUpdateCompanionBuilder =
    CalculationsCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<int> isDraft,
      Value<String> cachedTotal,
      Value<String?> currencyCode,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

final class $$CalculationsTableReferences
    extends BaseReferences<_$AppDatabase, $CalculationsTable, Calculation> {
  $$CalculationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LinesTable, List<Line>> _linesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lines,
    aliasName: $_aliasNameGenerator(db.calculations.id, db.lines.calculationId),
  );

  $$LinesTableProcessedTableManager get linesRefs {
    final manager = $$LinesTableTableManager(
      $_db,
      $_db.lines,
    ).filter((f) => f.calculationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_linesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CalculationsTableFilterComposer
    extends Composer<_$AppDatabase, $CalculationsTable> {
  $$CalculationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cachedTotal => $composableBuilder(
    column: $table.cachedTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> linesRefs(
    Expression<bool> Function($$LinesTableFilterComposer f) f,
  ) {
    final $$LinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lines,
      getReferencedColumn: (t) => t.calculationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LinesTableFilterComposer(
            $db: $db,
            $table: $db.lines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalculationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalculationsTable> {
  $$CalculationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cachedTotal => $composableBuilder(
    column: $table.cachedTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalculationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalculationsTable> {
  $$CalculationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get isDraft =>
      $composableBuilder(column: $table.isDraft, builder: (column) => column);

  GeneratedColumn<String> get cachedTotal => $composableBuilder(
    column: $table.cachedTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> linesRefs<T extends Object>(
    Expression<T> Function($$LinesTableAnnotationComposer a) f,
  ) {
    final $$LinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.lines,
      getReferencedColumn: (t) => t.calculationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LinesTableAnnotationComposer(
            $db: $db,
            $table: $db.lines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalculationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalculationsTable,
          Calculation,
          $$CalculationsTableFilterComposer,
          $$CalculationsTableOrderingComposer,
          $$CalculationsTableAnnotationComposer,
          $$CalculationsTableCreateCompanionBuilder,
          $$CalculationsTableUpdateCompanionBuilder,
          (Calculation, $$CalculationsTableReferences),
          Calculation,
          PrefetchHooks Function({bool linesRefs})
        > {
  $$CalculationsTableTableManager(_$AppDatabase db, $CalculationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalculationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalculationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalculationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> isDraft = const Value.absent(),
                Value<String> cachedTotal = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => CalculationsCompanion(
                id: id,
                name: name,
                isDraft: isDraft,
                cachedTotal: cachedTotal,
                currencyCode: currencyCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> isDraft = const Value.absent(),
                Value<String> cachedTotal = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                required int createdAt,
                required int updatedAt,
              }) => CalculationsCompanion.insert(
                id: id,
                name: name,
                isDraft: isDraft,
                cachedTotal: cachedTotal,
                currencyCode: currencyCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalculationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({linesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (linesRefs) db.lines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (linesRefs)
                    await $_getPrefetchedData<
                      Calculation,
                      $CalculationsTable,
                      Line
                    >(
                      currentTable: table,
                      referencedTable: $$CalculationsTableReferences
                          ._linesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CalculationsTableReferences(
                            db,
                            table,
                            p0,
                          ).linesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.calculationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CalculationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalculationsTable,
      Calculation,
      $$CalculationsTableFilterComposer,
      $$CalculationsTableOrderingComposer,
      $$CalculationsTableAnnotationComposer,
      $$CalculationsTableCreateCompanionBuilder,
      $$CalculationsTableUpdateCompanionBuilder,
      (Calculation, $$CalculationsTableReferences),
      Calculation,
      PrefetchHooks Function({bool linesRefs})
    >;
typedef $$LinesTableCreateCompanionBuilder =
    LinesCompanion Function({
      Value<int> id,
      required int calculationId,
      required int position,
      Value<String> rawExpression,
      Value<String> computedValue,
      Value<String?> comment,
      Value<int> isError,
    });
typedef $$LinesTableUpdateCompanionBuilder =
    LinesCompanion Function({
      Value<int> id,
      Value<int> calculationId,
      Value<int> position,
      Value<String> rawExpression,
      Value<String> computedValue,
      Value<String?> comment,
      Value<int> isError,
    });

final class $$LinesTableReferences
    extends BaseReferences<_$AppDatabase, $LinesTable, Line> {
  $$LinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CalculationsTable _calculationIdTable(_$AppDatabase db) =>
      db.calculations.createAlias(
        $_aliasNameGenerator(db.lines.calculationId, db.calculations.id),
      );

  $$CalculationsTableProcessedTableManager get calculationId {
    final $_column = $_itemColumn<int>('calculation_id')!;

    final manager = $$CalculationsTableTableManager(
      $_db,
      $_db.calculations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calculationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LinesTableFilterComposer extends Composer<_$AppDatabase, $LinesTable> {
  $$LinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawExpression => $composableBuilder(
    column: $table.rawExpression,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get computedValue => $composableBuilder(
    column: $table.computedValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isError => $composableBuilder(
    column: $table.isError,
    builder: (column) => ColumnFilters(column),
  );

  $$CalculationsTableFilterComposer get calculationId {
    final $$CalculationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableFilterComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LinesTableOrderingComposer
    extends Composer<_$AppDatabase, $LinesTable> {
  $$LinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawExpression => $composableBuilder(
    column: $table.rawExpression,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get computedValue => $composableBuilder(
    column: $table.computedValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isError => $composableBuilder(
    column: $table.isError,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalculationsTableOrderingComposer get calculationId {
    final $$CalculationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableOrderingComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LinesTable> {
  $$LinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get rawExpression => $composableBuilder(
    column: $table.rawExpression,
    builder: (column) => column,
  );

  GeneratedColumn<String> get computedValue => $composableBuilder(
    column: $table.computedValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<int> get isError =>
      $composableBuilder(column: $table.isError, builder: (column) => column);

  $$CalculationsTableAnnotationComposer get calculationId {
    final $$CalculationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calculationId,
      referencedTable: $db.calculations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalculationsTableAnnotationComposer(
            $db: $db,
            $table: $db.calculations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LinesTable,
          Line,
          $$LinesTableFilterComposer,
          $$LinesTableOrderingComposer,
          $$LinesTableAnnotationComposer,
          $$LinesTableCreateCompanionBuilder,
          $$LinesTableUpdateCompanionBuilder,
          (Line, $$LinesTableReferences),
          Line,
          PrefetchHooks Function({bool calculationId})
        > {
  $$LinesTableTableManager(_$AppDatabase db, $LinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> calculationId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> rawExpression = const Value.absent(),
                Value<String> computedValue = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> isError = const Value.absent(),
              }) => LinesCompanion(
                id: id,
                calculationId: calculationId,
                position: position,
                rawExpression: rawExpression,
                computedValue: computedValue,
                comment: comment,
                isError: isError,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int calculationId,
                required int position,
                Value<String> rawExpression = const Value.absent(),
                Value<String> computedValue = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<int> isError = const Value.absent(),
              }) => LinesCompanion.insert(
                id: id,
                calculationId: calculationId,
                position: position,
                rawExpression: rawExpression,
                computedValue: computedValue,
                comment: comment,
                isError: isError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LinesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({calculationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (calculationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.calculationId,
                                referencedTable: $$LinesTableReferences
                                    ._calculationIdTable(db),
                                referencedColumn: $$LinesTableReferences
                                    ._calculationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LinesTable,
      Line,
      $$LinesTableFilterComposer,
      $$LinesTableOrderingComposer,
      $$LinesTableAnnotationComposer,
      $$LinesTableCreateCompanionBuilder,
      $$LinesTableUpdateCompanionBuilder,
      (Line, $$LinesTableReferences),
      Line,
      PrefetchHooks Function({bool calculationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CalculationsTableTableManager get calculations =>
      $$CalculationsTableTableManager(_db, _db.calculations);
  $$LinesTableTableManager get lines =>
      $$LinesTableTableManager(_db, _db.lines);
}

mixin _$CalculationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CalculationsTable get calculations => attachedDatabase.calculations;
  $LinesTable get lines => attachedDatabase.lines;
  CalculationsDaoManager get managers => CalculationsDaoManager(this);
}

class CalculationsDaoManager {
  final _$CalculationsDaoMixin _db;
  CalculationsDaoManager(this._db);
  $$CalculationsTableTableManager get calculations =>
      $$CalculationsTableTableManager(_db.attachedDatabase, _db.calculations);
  $$LinesTableTableManager get lines =>
      $$LinesTableTableManager(_db.attachedDatabase, _db.lines);
}

mixin _$LinesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CalculationsTable get calculations => attachedDatabase.calculations;
  $LinesTable get lines => attachedDatabase.lines;
  LinesDaoManager get managers => LinesDaoManager(this);
}

class LinesDaoManager {
  final _$LinesDaoMixin _db;
  LinesDaoManager(this._db);
  $$CalculationsTableTableManager get calculations =>
      $$CalculationsTableTableManager(_db.attachedDatabase, _db.calculations);
  $$LinesTableTableManager get lines =>
      $$LinesTableTableManager(_db.attachedDatabase, _db.lines);
}

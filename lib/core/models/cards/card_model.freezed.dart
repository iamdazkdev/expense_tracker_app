// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CardModel _$CardModelFromJson(Map<String, dynamic> json) {
  return _CardModel.fromJson(json);
}

/// @nodoc
mixin _$CardModel {
  String? get uuid => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get holderName => throw _privateConstructorUsedError;
  String get accountNumber => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
  bool? get isDefault => throw _privateConstructorUsedError;
  double? get balance => throw _privateConstructorUsedError;
  double? get income => throw _privateConstructorUsedError;
  double? get expense =>
      throw _privateConstructorUsedError; // 🔔 Hạn mức chi tiêu được đặt cho thẻ
  double? get spendingLimit =>
      throw _privateConstructorUsedError; // ⏰ Bật tắt nhắc nhở khi vượt hạn mức
  bool? get isLimitReminderEnabled =>
      throw _privateConstructorUsedError; // 📅 Thời điểm lần cuối gửi cảnh báo (giúp tránh spam thông báo)
  DateTime? get lastLimitReminderSent => throw _privateConstructorUsedError;
  TransactionType? get transactionType => throw _privateConstructorUsedError;

  /// Serializes this CardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardModelCopyWith<CardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardModelCopyWith<$Res> {
  factory $CardModelCopyWith(CardModel value, $Res Function(CardModel) then) =
      _$CardModelCopyWithImpl<$Res, CardModel>;
  @useResult
  $Res call(
      {String? uuid,
      String? userId,
      String name,
      String holderName,
      String accountNumber,
      int color,
      bool? isDefault,
      double? balance,
      double? income,
      double? expense,
      double? spendingLimit,
      bool? isLimitReminderEnabled,
      DateTime? lastLimitReminderSent,
      TransactionType? transactionType});
}

/// @nodoc
class _$CardModelCopyWithImpl<$Res, $Val extends CardModel>
    implements $CardModelCopyWith<$Res> {
  _$CardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? userId = freezed,
    Object? name = null,
    Object? holderName = null,
    Object? accountNumber = null,
    Object? color = null,
    Object? isDefault = freezed,
    Object? balance = freezed,
    Object? income = freezed,
    Object? expense = freezed,
    Object? spendingLimit = freezed,
    Object? isLimitReminderEnabled = freezed,
    Object? lastLimitReminderSent = freezed,
    Object? transactionType = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      holderName: null == holderName
          ? _value.holderName
          : holderName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: freezed == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double?,
      income: freezed == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double?,
      expense: freezed == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double?,
      spendingLimit: freezed == spendingLimit
          ? _value.spendingLimit
          : spendingLimit // ignore: cast_nullable_to_non_nullable
              as double?,
      isLimitReminderEnabled: freezed == isLimitReminderEnabled
          ? _value.isLimitReminderEnabled
          : isLimitReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastLimitReminderSent: freezed == lastLimitReminderSent
          ? _value.lastLimitReminderSent
          : lastLimitReminderSent // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactionType: freezed == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CardModelImplCopyWith<$Res>
    implements $CardModelCopyWith<$Res> {
  factory _$$CardModelImplCopyWith(
          _$CardModelImpl value, $Res Function(_$CardModelImpl) then) =
      __$$CardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uuid,
      String? userId,
      String name,
      String holderName,
      String accountNumber,
      int color,
      bool? isDefault,
      double? balance,
      double? income,
      double? expense,
      double? spendingLimit,
      bool? isLimitReminderEnabled,
      DateTime? lastLimitReminderSent,
      TransactionType? transactionType});
}

/// @nodoc
class __$$CardModelImplCopyWithImpl<$Res>
    extends _$CardModelCopyWithImpl<$Res, _$CardModelImpl>
    implements _$$CardModelImplCopyWith<$Res> {
  __$$CardModelImplCopyWithImpl(
      _$CardModelImpl _value, $Res Function(_$CardModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? userId = freezed,
    Object? name = null,
    Object? holderName = null,
    Object? accountNumber = null,
    Object? color = null,
    Object? isDefault = freezed,
    Object? balance = freezed,
    Object? income = freezed,
    Object? expense = freezed,
    Object? spendingLimit = freezed,
    Object? isLimitReminderEnabled = freezed,
    Object? lastLimitReminderSent = freezed,
    Object? transactionType = freezed,
  }) {
    return _then(_$CardModelImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      holderName: null == holderName
          ? _value.holderName
          : holderName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: freezed == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double?,
      income: freezed == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double?,
      expense: freezed == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double?,
      spendingLimit: freezed == spendingLimit
          ? _value.spendingLimit
          : spendingLimit // ignore: cast_nullable_to_non_nullable
              as double?,
      isLimitReminderEnabled: freezed == isLimitReminderEnabled
          ? _value.isLimitReminderEnabled
          : isLimitReminderEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastLimitReminderSent: freezed == lastLimitReminderSent
          ? _value.lastLimitReminderSent
          : lastLimitReminderSent // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      transactionType: freezed == transactionType
          ? _value.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionType?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CardModelImpl implements _CardModel {
  const _$CardModelImpl(
      {required this.uuid,
      required this.userId,
      required this.name,
      required this.holderName,
      required this.accountNumber,
      required this.color,
      this.isDefault,
      this.balance,
      this.income,
      this.expense,
      this.spendingLimit,
      this.isLimitReminderEnabled,
      this.lastLimitReminderSent,
      this.transactionType});

  factory _$CardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardModelImplFromJson(json);

  @override
  final String? uuid;
  @override
  final String? userId;
  @override
  final String name;
  @override
  final String holderName;
  @override
  final String accountNumber;
  @override
  final int color;
  @override
  final bool? isDefault;
  @override
  final double? balance;
  @override
  final double? income;
  @override
  final double? expense;
// 🔔 Hạn mức chi tiêu được đặt cho thẻ
  @override
  final double? spendingLimit;
// ⏰ Bật tắt nhắc nhở khi vượt hạn mức
  @override
  final bool? isLimitReminderEnabled;
// 📅 Thời điểm lần cuối gửi cảnh báo (giúp tránh spam thông báo)
  @override
  final DateTime? lastLimitReminderSent;
  @override
  final TransactionType? transactionType;

  @override
  String toString() {
    return 'CardModel(uuid: $uuid, userId: $userId, name: $name, holderName: $holderName, accountNumber: $accountNumber, color: $color, isDefault: $isDefault, balance: $balance, income: $income, expense: $expense, spendingLimit: $spendingLimit, isLimitReminderEnabled: $isLimitReminderEnabled, lastLimitReminderSent: $lastLimitReminderSent, transactionType: $transactionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardModelImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.holderName, holderName) ||
                other.holderName == holderName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.spendingLimit, spendingLimit) ||
                other.spendingLimit == spendingLimit) &&
            (identical(other.isLimitReminderEnabled, isLimitReminderEnabled) ||
                other.isLimitReminderEnabled == isLimitReminderEnabled) &&
            (identical(other.lastLimitReminderSent, lastLimitReminderSent) ||
                other.lastLimitReminderSent == lastLimitReminderSent) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      userId,
      name,
      holderName,
      accountNumber,
      color,
      isDefault,
      balance,
      income,
      expense,
      spendingLimit,
      isLimitReminderEnabled,
      lastLimitReminderSent,
      transactionType);

  /// Create a copy of CardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardModelImplCopyWith<_$CardModelImpl> get copyWith =>
      __$$CardModelImplCopyWithImpl<_$CardModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardModelImplToJson(
      this,
    );
  }
}

abstract class _CardModel implements CardModel {
  const factory _CardModel(
      {required final String? uuid,
      required final String? userId,
      required final String name,
      required final String holderName,
      required final String accountNumber,
      required final int color,
      final bool? isDefault,
      final double? balance,
      final double? income,
      final double? expense,
      final double? spendingLimit,
      final bool? isLimitReminderEnabled,
      final DateTime? lastLimitReminderSent,
      final TransactionType? transactionType}) = _$CardModelImpl;

  factory _CardModel.fromJson(Map<String, dynamic> json) =
      _$CardModelImpl.fromJson;

  @override
  String? get uuid;
  @override
  String? get userId;
  @override
  String get name;
  @override
  String get holderName;
  @override
  String get accountNumber;
  @override
  int get color;
  @override
  bool? get isDefault;
  @override
  double? get balance;
  @override
  double? get income;
  @override
  double? get expense; // 🔔 Hạn mức chi tiêu được đặt cho thẻ
  @override
  double? get spendingLimit; // ⏰ Bật tắt nhắc nhở khi vượt hạn mức
  @override
  bool?
      get isLimitReminderEnabled; // 📅 Thời điểm lần cuối gửi cảnh báo (giúp tránh spam thông báo)
  @override
  DateTime? get lastLimitReminderSent;
  @override
  TransactionType? get transactionType;

  /// Create a copy of CardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardModelImplCopyWith<_$CardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

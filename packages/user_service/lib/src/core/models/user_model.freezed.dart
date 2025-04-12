// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$User {
  String? get uuid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  int? get birthYear => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String? uuid,
    String email,
    String fullName,
    String? photoUrl,
    String? phoneNumber,
    int? birthYear,
  });
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? email = null,
    Object? fullName = null,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? birthYear = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid ? _value.uuid : uuid as String?,
      email: null == email ? _value.email : email as String,
      fullName: null == fullName ? _value.fullName : fullName as String,
      photoUrl: freezed == photoUrl ? _value.photoUrl : photoUrl as String?,
      phoneNumber:
          freezed == phoneNumber ? _value.phoneNumber : phoneNumber as String?,
      birthYear: freezed == birthYear ? _value.birthYear : birthYear as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? uuid,
    String email,
    String fullName,
    String? photoUrl,
    String? phoneNumber,
    int? birthYear,
  });
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? email = null,
    Object? fullName = null,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? birthYear = freezed,
  }) {
    return _then(_$UserImpl(
      uuid: freezed == uuid ? _value.uuid : uuid as String?,
      email: null == email ? _value.email : email as String,
      fullName: null == fullName ? _value.fullName : fullName as String,
      photoUrl: freezed == photoUrl ? _value.photoUrl : photoUrl as String?,
      phoneNumber:
          freezed == phoneNumber ? _value.phoneNumber : phoneNumber as String?,
      birthYear: freezed == birthYear ? _value.birthYear : birthYear as int?,
    ));
  }
}

/// @nodoc

class _$UserImpl implements _User {
  const _$UserImpl({
    required this.uuid,
    required this.email,
    required this.fullName,
    required this.photoUrl,
    required this.phoneNumber,
    required this.birthYear,
  });

  @override
  final String? uuid;
  @override
  final String email;
  @override
  final String fullName;
  @override
  final String? photoUrl;
  @override
  final String? phoneNumber;
  @override
  final int? birthYear;

  @override
  String toString() {
    return 'User(uuid: $uuid, email: $email, fullName: $fullName, photoUrl: $photoUrl, phoneNumber: $phoneNumber, birthYear: $birthYear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.birthYear, birthYear) ||
                other.birthYear == birthYear));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, uuid, email, fullName, photoUrl, phoneNumber, birthYear);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);
}

abstract class _User implements User {
  const factory _User({
    required final String? uuid,
    required final String email,
    required final String fullName,
    required final String? photoUrl,
    required final String? phoneNumber,
    required final int? birthYear,
  }) = _$UserImpl;

  @override
  String? get uuid;
  @override
  String get email;
  @override
  String get fullName;
  @override
  String? get photoUrl;
  @override
  String? get phoneNumber;
  @override
  int? get birthYear;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

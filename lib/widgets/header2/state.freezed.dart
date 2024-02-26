// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Header2State {
  Header2? get header2 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Header2? header2) empty,
    required TResult Function(Header2 header2, ModelSettings modelSettings)
        withModelSettings,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Header2? header2)? empty,
    TResult? Function(Header2 header2, ModelSettings modelSettings)?
        withModelSettings,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Header2? header2)? empty,
    TResult Function(Header2 header2, ModelSettings modelSettings)?
        withModelSettings,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(Header2StateWithModelSettings value)
        withModelSettings,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(Header2StateWithModelSettings value)? withModelSettings,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(Header2StateWithModelSettings value)? withModelSettings,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $Header2StateCopyWith<Header2State> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Header2StateCopyWith<$Res> {
  factory $Header2StateCopyWith(
          Header2State value, $Res Function(Header2State) then) =
      _$Header2StateCopyWithImpl<$Res, Header2State>;
  @useResult
  $Res call({Header2 header2});
}

/// @nodoc
class _$Header2StateCopyWithImpl<$Res, $Val extends Header2State>
    implements $Header2StateCopyWith<$Res> {
  _$Header2StateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? header2 = null,
  }) {
    return _then(_value.copyWith(
      header2: null == header2
          ? _value.header2!
          : header2 // ignore: cast_nullable_to_non_nullable
              as Header2,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmptyImplCopyWith<$Res>
    implements $Header2StateCopyWith<$Res> {
  factory _$$EmptyImplCopyWith(
          _$EmptyImpl value, $Res Function(_$EmptyImpl) then) =
      __$$EmptyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Header2? header2});
}

/// @nodoc
class __$$EmptyImplCopyWithImpl<$Res>
    extends _$Header2StateCopyWithImpl<$Res, _$EmptyImpl>
    implements _$$EmptyImplCopyWith<$Res> {
  __$$EmptyImplCopyWithImpl(
      _$EmptyImpl _value, $Res Function(_$EmptyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? header2 = freezed,
  }) {
    return _then(_$EmptyImpl(
      header2: freezed == header2
          ? _value.header2
          : header2 // ignore: cast_nullable_to_non_nullable
              as Header2?,
    ));
  }
}

/// @nodoc

class _$EmptyImpl implements _Empty {
  const _$EmptyImpl({this.header2});

  @override
  final Header2? header2;

  @override
  String toString() {
    return 'Header2State.empty(header2: $header2)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmptyImpl &&
            (identical(other.header2, header2) || other.header2 == header2));
  }

  @override
  int get hashCode => Object.hash(runtimeType, header2);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmptyImplCopyWith<_$EmptyImpl> get copyWith =>
      __$$EmptyImplCopyWithImpl<_$EmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Header2? header2) empty,
    required TResult Function(Header2 header2, ModelSettings modelSettings)
        withModelSettings,
  }) {
    return empty(header2);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Header2? header2)? empty,
    TResult? Function(Header2 header2, ModelSettings modelSettings)?
        withModelSettings,
  }) {
    return empty?.call(header2);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Header2? header2)? empty,
    TResult Function(Header2 header2, ModelSettings modelSettings)?
        withModelSettings,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(header2);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(Header2StateWithModelSettings value)
        withModelSettings,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(Header2StateWithModelSettings value)? withModelSettings,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(Header2StateWithModelSettings value)? withModelSettings,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _Empty implements Header2State {
  const factory _Empty({final Header2? header2}) = _$EmptyImpl;

  @override
  Header2? get header2;
  @override
  @JsonKey(ignore: true)
  _$$EmptyImplCopyWith<_$EmptyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Header2StateWithModelSettingsImplCopyWith<$Res>
    implements $Header2StateCopyWith<$Res> {
  factory _$$Header2StateWithModelSettingsImplCopyWith(
          _$Header2StateWithModelSettingsImpl value,
          $Res Function(_$Header2StateWithModelSettingsImpl) then) =
      __$$Header2StateWithModelSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Header2 header2, ModelSettings modelSettings});
}

/// @nodoc
class __$$Header2StateWithModelSettingsImplCopyWithImpl<$Res>
    extends _$Header2StateCopyWithImpl<$Res,
        _$Header2StateWithModelSettingsImpl>
    implements _$$Header2StateWithModelSettingsImplCopyWith<$Res> {
  __$$Header2StateWithModelSettingsImplCopyWithImpl(
      _$Header2StateWithModelSettingsImpl _value,
      $Res Function(_$Header2StateWithModelSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? header2 = null,
    Object? modelSettings = null,
  }) {
    return _then(_$Header2StateWithModelSettingsImpl(
      header2: null == header2
          ? _value.header2
          : header2 // ignore: cast_nullable_to_non_nullable
              as Header2,
      modelSettings: null == modelSettings
          ? _value.modelSettings
          : modelSettings // ignore: cast_nullable_to_non_nullable
              as ModelSettings,
    ));
  }
}

/// @nodoc

class _$Header2StateWithModelSettingsImpl
    implements Header2StateWithModelSettings {
  const _$Header2StateWithModelSettingsImpl(
      {required this.header2, required this.modelSettings});

  @override
  final Header2 header2;
  @override
  final ModelSettings modelSettings;

  @override
  String toString() {
    return 'Header2State.withModelSettings(header2: $header2, modelSettings: $modelSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Header2StateWithModelSettingsImpl &&
            (identical(other.header2, header2) || other.header2 == header2) &&
            (identical(other.modelSettings, modelSettings) ||
                other.modelSettings == modelSettings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, header2, modelSettings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Header2StateWithModelSettingsImplCopyWith<
          _$Header2StateWithModelSettingsImpl>
      get copyWith => __$$Header2StateWithModelSettingsImplCopyWithImpl<
          _$Header2StateWithModelSettingsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Header2? header2) empty,
    required TResult Function(Header2 header2, ModelSettings modelSettings)
        withModelSettings,
  }) {
    return withModelSettings(header2, modelSettings);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Header2? header2)? empty,
    TResult? Function(Header2 header2, ModelSettings modelSettings)?
        withModelSettings,
  }) {
    return withModelSettings?.call(header2, modelSettings);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Header2? header2)? empty,
    TResult Function(Header2 header2, ModelSettings modelSettings)?
        withModelSettings,
    required TResult orElse(),
  }) {
    if (withModelSettings != null) {
      return withModelSettings(header2, modelSettings);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(Header2StateWithModelSettings value)
        withModelSettings,
  }) {
    return withModelSettings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(Header2StateWithModelSettings value)? withModelSettings,
  }) {
    return withModelSettings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(Header2StateWithModelSettings value)? withModelSettings,
    required TResult orElse(),
  }) {
    if (withModelSettings != null) {
      return withModelSettings(this);
    }
    return orElse();
  }
}

abstract class Header2StateWithModelSettings implements Header2State {
  const factory Header2StateWithModelSettings(
          {required final Header2 header2,
          required final ModelSettings modelSettings}) =
      _$Header2StateWithModelSettingsImpl;

  @override
  Header2 get header2;
  ModelSettings get modelSettings;
  @override
  @JsonKey(ignore: true)
  _$$Header2StateWithModelSettingsImplCopyWith<
          _$Header2StateWithModelSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

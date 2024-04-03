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
mixin _$ModelViewerSelectionState {
  List<ModelSettings> get models => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ModelSettings> models) empty,
    required TResult Function(List<ModelSettings> models, ModelSettings model,
            ChunkAttributes filter, dynamic showCloth)
        withModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ModelSettings> models)? empty,
    TResult? Function(List<ModelSettings> models, ModelSettings model,
            ChunkAttributes filter, dynamic showCloth)?
        withModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ModelSettings> models)? empty,
    TResult Function(List<ModelSettings> models, ModelSettings model,
            ChunkAttributes filter, dynamic showCloth)?
        withModel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(ModelViewerSelectionStateWithModel value)
        withModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(ModelViewerSelectionStateWithModel value)? withModel,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(ModelViewerSelectionStateWithModel value)? withModel,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ModelViewerSelectionStateCopyWith<ModelViewerSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelViewerSelectionStateCopyWith<$Res> {
  factory $ModelViewerSelectionStateCopyWith(ModelViewerSelectionState value,
          $Res Function(ModelViewerSelectionState) then) =
      _$ModelViewerSelectionStateCopyWithImpl<$Res, ModelViewerSelectionState>;
  @useResult
  $Res call({List<ModelSettings> models});
}

/// @nodoc
class _$ModelViewerSelectionStateCopyWithImpl<$Res,
        $Val extends ModelViewerSelectionState>
    implements $ModelViewerSelectionStateCopyWith<$Res> {
  _$ModelViewerSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? models = null,
  }) {
    return _then(_value.copyWith(
      models: null == models
          ? _value.models
          : models // ignore: cast_nullable_to_non_nullable
              as List<ModelSettings>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmptyImplCopyWith<$Res>
    implements $ModelViewerSelectionStateCopyWith<$Res> {
  factory _$$EmptyImplCopyWith(
          _$EmptyImpl value, $Res Function(_$EmptyImpl) then) =
      __$$EmptyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ModelSettings> models});
}

/// @nodoc
class __$$EmptyImplCopyWithImpl<$Res>
    extends _$ModelViewerSelectionStateCopyWithImpl<$Res, _$EmptyImpl>
    implements _$$EmptyImplCopyWith<$Res> {
  __$$EmptyImplCopyWithImpl(
      _$EmptyImpl _value, $Res Function(_$EmptyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? models = null,
  }) {
    return _then(_$EmptyImpl(
      null == models
          ? _value._models
          : models // ignore: cast_nullable_to_non_nullable
              as List<ModelSettings>,
    ));
  }
}

/// @nodoc

class _$EmptyImpl implements _Empty {
  const _$EmptyImpl(final List<ModelSettings> models) : _models = models;

  final List<ModelSettings> _models;
  @override
  List<ModelSettings> get models {
    if (_models is EqualUnmodifiableListView) return _models;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_models);
  }

  @override
  String toString() {
    return 'ModelViewerSelectionState.empty(models: $models)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmptyImpl &&
            const DeepCollectionEquality().equals(other._models, _models));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_models));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmptyImplCopyWith<_$EmptyImpl> get copyWith =>
      __$$EmptyImplCopyWithImpl<_$EmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ModelSettings> models) empty,
    required TResult Function(List<ModelSettings> models, ModelSettings model,
            ChunkAttributes filter, dynamic showCloth)
        withModel,
  }) {
    return empty(models);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ModelSettings> models)? empty,
    TResult? Function(List<ModelSettings> models, ModelSettings model,
            ChunkAttributes filter, dynamic showCloth)?
        withModel,
  }) {
    return empty?.call(models);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ModelSettings> models)? empty,
    TResult Function(List<ModelSettings> models, ModelSettings model,
            ChunkAttributes filter, dynamic showCloth)?
        withModel,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(models);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(ModelViewerSelectionStateWithModel value)
        withModel,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(ModelViewerSelectionStateWithModel value)? withModel,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(ModelViewerSelectionStateWithModel value)? withModel,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _Empty implements ModelViewerSelectionState {
  const factory _Empty(final List<ModelSettings> models) = _$EmptyImpl;

  @override
  List<ModelSettings> get models;
  @override
  @JsonKey(ignore: true)
  _$$EmptyImplCopyWith<_$EmptyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ModelViewerSelectionStateWithModelImplCopyWith<$Res>
    implements $ModelViewerSelectionStateCopyWith<$Res> {
  factory _$$ModelViewerSelectionStateWithModelImplCopyWith(
          _$ModelViewerSelectionStateWithModelImpl value,
          $Res Function(_$ModelViewerSelectionStateWithModelImpl) then) =
      __$$ModelViewerSelectionStateWithModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ModelSettings> models,
      ModelSettings model,
      ChunkAttributes filter,
      dynamic showCloth});
}

/// @nodoc
class __$$ModelViewerSelectionStateWithModelImplCopyWithImpl<$Res>
    extends _$ModelViewerSelectionStateCopyWithImpl<$Res,
        _$ModelViewerSelectionStateWithModelImpl>
    implements _$$ModelViewerSelectionStateWithModelImplCopyWith<$Res> {
  __$$ModelViewerSelectionStateWithModelImplCopyWithImpl(
      _$ModelViewerSelectionStateWithModelImpl _value,
      $Res Function(_$ModelViewerSelectionStateWithModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? models = null,
    Object? model = null,
    Object? filter = null,
    Object? showCloth = freezed,
  }) {
    return _then(_$ModelViewerSelectionStateWithModelImpl(
      models: null == models
          ? _value._models
          : models // ignore: cast_nullable_to_non_nullable
              as List<ModelSettings>,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as ModelSettings,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as ChunkAttributes,
      showCloth: freezed == showCloth ? _value.showCloth! : showCloth,
    ));
  }
}

/// @nodoc

class _$ModelViewerSelectionStateWithModelImpl
    implements ModelViewerSelectionStateWithModel {
  const _$ModelViewerSelectionStateWithModelImpl(
      {required final List<ModelSettings> models,
      required this.model,
      required this.filter,
      this.showCloth = false})
      : _models = models;

  final List<ModelSettings> _models;
  @override
  List<ModelSettings> get models {
    if (_models is EqualUnmodifiableListView) return _models;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_models);
  }

  @override
  final ModelSettings model;
  @override
  final ChunkAttributes filter;
  @override
  @JsonKey()
  final dynamic showCloth;

  @override
  String toString() {
    return 'ModelViewerSelectionState.withModel(models: $models, model: $model, filter: $filter, showCloth: $showCloth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelViewerSelectionStateWithModelImpl &&
            const DeepCollectionEquality().equals(other._models, _models) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            const DeepCollectionEquality().equals(other.showCloth, showCloth));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_models),
      model,
      filter,
      const DeepCollectionEquality().hash(showCloth));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelViewerSelectionStateWithModelImplCopyWith<
          _$ModelViewerSelectionStateWithModelImpl>
      get copyWith => __$$ModelViewerSelectionStateWithModelImplCopyWithImpl<
          _$ModelViewerSelectionStateWithModelImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ModelSettings> models) empty,
    required TResult Function(List<ModelSettings> models, ModelSettings model,
            ChunkAttributes filter, dynamic showCloth)
        withModel,
  }) {
    return withModel(models, model, filter, showCloth);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ModelSettings> models)? empty,
    TResult? Function(List<ModelSettings> models, ModelSettings model,
            ChunkAttributes filter, dynamic showCloth)?
        withModel,
  }) {
    return withModel?.call(models, model, filter, showCloth);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ModelSettings> models)? empty,
    TResult Function(List<ModelSettings> models, ModelSettings model,
            ChunkAttributes filter, dynamic showCloth)?
        withModel,
    required TResult orElse(),
  }) {
    if (withModel != null) {
      return withModel(models, model, filter, showCloth);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Empty value) empty,
    required TResult Function(ModelViewerSelectionStateWithModel value)
        withModel,
  }) {
    return withModel(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Empty value)? empty,
    TResult? Function(ModelViewerSelectionStateWithModel value)? withModel,
  }) {
    return withModel?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Empty value)? empty,
    TResult Function(ModelViewerSelectionStateWithModel value)? withModel,
    required TResult orElse(),
  }) {
    if (withModel != null) {
      return withModel(this);
    }
    return orElse();
  }
}

abstract class ModelViewerSelectionStateWithModel
    implements ModelViewerSelectionState {
  const factory ModelViewerSelectionStateWithModel(
      {required final List<ModelSettings> models,
      required final ModelSettings model,
      required final ChunkAttributes filter,
      final dynamic showCloth}) = _$ModelViewerSelectionStateWithModelImpl;

  @override
  List<ModelSettings> get models;
  ModelSettings get model;
  ChunkAttributes get filter;
  dynamic get showCloth;
  @override
  @JsonKey(ignore: true)
  _$$ModelViewerSelectionStateWithModelImplCopyWith<
          _$ModelViewerSelectionStateWithModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
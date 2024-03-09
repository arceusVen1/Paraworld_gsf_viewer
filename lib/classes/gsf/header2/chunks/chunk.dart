import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

enum ChunkType {
  mesh,
  meshSkinned,
  meshSkinnedSimple,
  cloth,
  clothSkinned,
  clothSkinnedSimple,
  billboard,
  billboardSkinned,
  particle,
  particleSkinned,
  skeleton,
  collisionPhysics,
  collisionPhysicsSkinned,
  speedline,
  speedlineSkinned,
  selectionVolume,
  selectionVolumeSkinned,
  positionLink,
  boneLink,
  unknown,
}

extension ChunkTypeExtension on ChunkType {
  // skinned chunks correspond to chunk with bone weight and relation
  // https://forum.unity.com/threads/stupid-question-of-the-day-whats-the-difference-between-a-skinned-mesh-and-a-non-skinned-mesh.379701/
  bool isSkinned() {
    return value & 0x80000000 != 0 || this == ChunkType.meshSkinnedSimple;
  }

  bool isMeshLike() {
    return this == ChunkType.mesh ||
        this == ChunkType.meshSkinned ||
        this == ChunkType.meshSkinnedSimple;
  }

  int get value {
    switch (this) {
      case ChunkType.mesh:
        return 0x00000000;
      case ChunkType.billboard:
        return 0x00000001;
      case ChunkType.particle:
        return 0x00000002;
      case ChunkType.skeleton:
        return 0x00000005;
      case ChunkType.cloth:
        return 0x00000009;
      case ChunkType.collisionPhysics:
        return 0x0000000A;
      case ChunkType.positionLink:
        return 0x0000000B;
      case ChunkType.speedline:
        return 0x0000000E;
      case ChunkType.meshSkinned:
        return 0x80000000;
      case ChunkType.billboardSkinned:
        return 0x80000001;
      case ChunkType.particleSkinned:
        return 0x80000005;
      case ChunkType.clothSkinned:
        return 0x80000009;
      case ChunkType.collisionPhysicsSkinned:
        return 0x8000000A;
      case ChunkType.boneLink:
        return 0x8000000B;
      case ChunkType.speedlineSkinned:
        return 0x8000000E;
      case ChunkType.meshSkinnedSimple:
        return 0x20000000;
      case ChunkType.clothSkinnedSimple:
        return 0x20000009;
      case ChunkType.selectionVolume:
        return 0x0000000D;
      case ChunkType.selectionVolumeSkinned:
        return 0x8000000D;
      case ChunkType.unknown:
        return 0x00000008;
    }
  }

  static ChunkType fromInt(int value) {
    switch (value) {
      case 0x00000000:
        return ChunkType.mesh;
      case 0x00000001:
        return ChunkType.billboard;
      case 0x00000002:
        return ChunkType.particle;
      case 0x00000005:
        return ChunkType.skeleton;
      case 0x00000009:
        return ChunkType.cloth;
      case 0x0000000A:
        return ChunkType.collisionPhysics;
      case 0x0000000B:
        return ChunkType.positionLink;
      case 0x0000000E:
        return ChunkType.speedline;
      case 0x80000000:
        return ChunkType.meshSkinned;
      case 0x80000001:
        return ChunkType.billboardSkinned;
      case 0x80000002:
        return ChunkType.particleSkinned;
      case 0x80000009:
        return ChunkType.clothSkinned;
      case 0x8000000A:
        return ChunkType.collisionPhysicsSkinned;
      case 0x8000000B:
        return ChunkType.boneLink;
      case 0x8000000E:
        return ChunkType.speedlineSkinned;
      case 0x20000000:
        return ChunkType.meshSkinnedSimple;
      case 0x20000009:
        return ChunkType.clothSkinnedSimple;
      case 0x0000000D:
        return ChunkType.selectionVolume;
      case 0x8000000D:
        return ChunkType.selectionVolumeSkinned;
      case 0x00000008:
        return ChunkType.unknown;
      default:
        throw Exception('Unknown chunk type: 0x${value.toRadixString(16)}');
    }
  }
}

class Chunk extends GsfPart {
  Chunk({required super.offset, required this.type});

  late final ChunkType type;

  @override
  String get label => 'Chunk ${type.name} (0x${type.value.toRadixString(16)})';
}

import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

enum ChunkType {
    mesh,
  billboard,
  particle,
  skeleton,
  cloth,
  collisionPhysics,
  positionLink,
  soundSphere,
  speedline,
  meshSkinned,
  billboardSkinned,
  particleSkinned,
  skeletonSkinned,
  clothSkinned,
  collisionPhysicsSkinned,
  boneLink,
  soundSphereSkinned,
  speedlineSkinned,
  unknown,
}


extension ChunkTypeExtension on ChunkType {
  // skinned chunks correspond to chunk with bone weight and relation
  // https://forum.unity.com/threads/stupid-question-of-the-day-whats-the-difference-between-a-skinned-mesh-and-a-non-skinned-mesh.379701/
  bool isSkinned() {
    return value & 0x80000000 != 0;
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
      case ChunkType.soundSphere:
        return 0x0000000D;
      case ChunkType.speedline:
        return 0x0000000E;
      case ChunkType.meshSkinned:
        return 0x80000000;
      case ChunkType.billboardSkinned:
        return 0x80000001;
      case ChunkType.particleSkinned:
        return 0x80000002;
      case ChunkType.skeletonSkinned:
        return 0x80000005;
      case ChunkType.clothSkinned:
        return 0x80000009;
      case ChunkType.collisionPhysicsSkinned:
        return 0x8000000A;
      case ChunkType.boneLink:
        return 0x8000000B;
      case ChunkType.soundSphereSkinned:
        return 0x8000000D;
      case ChunkType.speedlineSkinned:
        return 0x8000000E;
      case ChunkType.unknown:
        return 0x20000000; // TODO: there may be other values
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
      case 0x0000000D:
        return ChunkType.soundSphere;
      case 0x0000000E:
        return ChunkType.speedline;
      case 0x80000000:
        return ChunkType.meshSkinned;
      case 0x80000001:
        return ChunkType.billboardSkinned;
      case 0x80000002:
        return ChunkType.particleSkinned;
      case 0x80000005:
        return ChunkType.skeletonSkinned;
      case 0x80000009:
        return ChunkType.clothSkinned;
      case 0x8000000A:
        return ChunkType.collisionPhysicsSkinned;
      case 0x8000000B:
        return ChunkType.boneLink;
      case 0x8000000D:
        return ChunkType.soundSphereSkinned;
      case 0x8000000E:
        return ChunkType.speedlineSkinned;
      default:
        return ChunkType.unknown;
    }
  }
}

class Chunk extends GsfPart {
  Chunk({required super.offset, required this.type});

  late final ChunkType type;

  @override
  GsfData<String>? get name => null;

  @override
  String get label => 'Chunk ${type.name} (0x${type.value.toRadixString(16)})';
}

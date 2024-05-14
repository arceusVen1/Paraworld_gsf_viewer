import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/link.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/cloth.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/skeleton.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ChunksTable extends GsfPart {
  final int count; // read from model infos
  final List<Standard4BytesData<SignedInt>> chunksOffsets = [];
  final List<Chunk> chunks = [];

  @override
  String get label => "$count chunks";

  ChunksTable.fromBytes(
    Uint8List bytes,
    int offset,
    this.count,
  ) : super(offset: offset) {
    for (var i = 0; i < count; i++) {
      chunksOffsets.add(Standard4BytesData(
        position: 0,
        bytes: bytes,
        offset: chunksOffsets.isNotEmpty
            ? chunksOffsets.last.offsettedLength
            : offset,
      ));
    }

    for (var i = 0; i < chunksOffsets.length; i++) {
      final typeData = Standard4BytesData<int>(
        position: 0,
        bytes: bytes,
        offset: chunksOffsets[i].offset + chunksOffsets[i].value.value,
      );
      final ChunkType type = ChunkTypeExtension.fromInt(typeData.value);
      if (type == ChunkType.unknown) {
        print('Unknown chunk type !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      }
      final Chunk chunk = () {
        switch (type) {
          case ChunkType.meshSkinnedSimple:
          case ChunkType.meshSkinned:
          case ChunkType.mesh:
            return MeshChunk.fromBytes(
              bytes,
              typeData.offsettedLength,
              type,
            );
          case ChunkType.clothSkinnedSimple:
          case ChunkType.clothSkinned:
          case ChunkType.cloth:
            return ClothChunk.fromBytes(
              bytes,
              typeData.offsettedLength,
              type,
            );
          case ChunkType.skeleton:
            return SkeletonChunk.fromBytes(
              bytes,
              typeData.offsettedLength,
            );
          case ChunkType.positionLink:
          case ChunkType.boneLink:
            return LinkChunk.fromBytes(
              bytes,
              typeData.offsettedLength,
              type,
            );
          default:
            return Chunk(offset: typeData.offsettedLength, type: type);
        }
      }();

      chunks.add(chunk);
    }
  }

  @override
  int getEndOffset() =>
      chunksOffsets.isNotEmpty ? chunksOffsets.last.offsettedLength : offset;

  @override
  String toString() {
    return 'ChunksTable: $count';
  }
}

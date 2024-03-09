import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ChunksTable extends GsfPart {
  final int count; // read from model settings
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

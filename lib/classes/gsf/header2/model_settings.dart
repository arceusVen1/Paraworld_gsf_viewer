import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/fallback_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/object_name.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ModelSettings extends GsfPart {
  late final GsfData<String> name;
  late final Standard4BytesData<int> objectNameRelativeOffset;
  late final ObjectName objectName;
  late final Standard4BytesData<int> chunksTableRelativeOffset;
  late final Standard4BytesData<int> chunksCount;

  late final Standard4BytesData<int> fallbackTableRelativeOffset;
  late final Standard4BytesData<bool> readData;
  late final DoubleByteData<int> firstParticleChunkIndex;
  late final DoubleByteData<int> particleChunksCount;
  late final DoubleByteData<int> firstLinkChunkIndex;
  late final DoubleByteData<int> linkChunksCount;
  late final SingleByteData<bool> miscChunkExistsFlag;
  late final SingleByteData<int> skeletonChunksCount;
  late final SingleByteData<int> collysionPhycicsChunksCount;
  late final SingleByteData<int> clothChunksCount;
  late final SingleByteData<int> firstSelectionVolumeChunkIndex;
  late final SingleByteData<int> selectionVolumeChunksCount;
  late final SingleByteData<int> speedlineChunksCount;
  late final SingleByteData<int> zero;
  late final Standard4BytesData<int> unusedOffset;
  late final Standard4BytesData<int> pathFinderTableOffset;
  late final Standard4BytesData<int> pathFinderTableCount;
  late final BoundingBox boundingBox;
  late final Standard4BytesData<int> animChunksTableHeaderOffset;
  late final Standard4BytesData<int> animObjectCount;

  late final ChunksTable? chunksTable;
  late final FallbackTable? fallbackTable;
  @override
  String get label => "${name.value} (${objectName.label})";

  ModelSettings.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    name = Standard4BytesData<String>(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    objectNameRelativeOffset = Standard4BytesData(
      position: name.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    objectName = ObjectName.fromBytes(
      bytes,
      offset +
          objectNameRelativeOffset.relativePos +
          objectNameRelativeOffset.value,
    );

    chunksTableRelativeOffset = Standard4BytesData(
      position: objectNameRelativeOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    chunksCount = Standard4BytesData(
      position: chunksTableRelativeOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    if (chunksCount.value > 0) {
      chunksTable = ChunksTable.fromBytes(
        bytes,
        offset +
            chunksTableRelativeOffset.relativePos +
            chunksTableRelativeOffset.value,
        chunksCount.value,
      );
    }

    fallbackTableRelativeOffset = Standard4BytesData(
      position: chunksCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    if (!fallbackTableRelativeOffset.isUnused) {
      fallbackTable = FallbackTable.fromBytes(
        bytes,
        fallbackTableRelativeOffset.offsettedPos +
            fallbackTableRelativeOffset.value,
      );
    } else {
      fallbackTable = null;
    }

    readData = Standard4BytesData(
      position: fallbackTableRelativeOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    firstParticleChunkIndex = DoubleByteData(
      relativePos: readData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    particleChunksCount = DoubleByteData(
      relativePos: firstParticleChunkIndex.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    firstLinkChunkIndex = DoubleByteData(
      relativePos: particleChunksCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    linkChunksCount = DoubleByteData(
      relativePos: firstLinkChunkIndex.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    miscChunkExistsFlag = SingleByteData(
      relativePos: linkChunksCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    skeletonChunksCount = SingleByteData(
      relativePos: miscChunkExistsFlag.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    collysionPhycicsChunksCount = SingleByteData(
      relativePos: skeletonChunksCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    clothChunksCount = SingleByteData(
      relativePos: collysionPhycicsChunksCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    firstSelectionVolumeChunkIndex = SingleByteData(
      relativePos: clothChunksCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    selectionVolumeChunksCount = SingleByteData(
      relativePos: firstSelectionVolumeChunkIndex.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    speedlineChunksCount = SingleByteData(
      relativePos: selectionVolumeChunksCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    zero = SingleByteData(
      relativePos: speedlineChunksCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    assert(zero.value == 0, 'Zero is not zero');
    unusedOffset = Standard4BytesData(
      position: zero.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    pathFinderTableOffset = Standard4BytesData(
      position: unusedOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    pathFinderTableCount = Standard4BytesData(
      position: pathFinderTableOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    boundingBox = BoundingBox.fromBytes(
      bytes,
      pathFinderTableCount.offsettedLength,
    );
    animChunksTableHeaderOffset = Standard4BytesData(
      position: pathFinderTableCount.relativeEnd + boundingBox.length,
      bytes: bytes,
      offset: offset,
    );
    animObjectCount = Standard4BytesData(
      position: animChunksTableHeaderOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
  }

  @override
  int getEndOffset() {
    return animObjectCount.offsettedLength;
  }
}

import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/bouding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/object_name.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';

class ModelSettings extends GsfPart {
  late final GsfData<String> name;
  late final Standard4BytesData<int> objectNameRelativeOffset;
  late final ObjectName objectName;
  late final Standard4BytesData<int> chunksTableRelativeOffset;
  late final Standard4BytesData<int> chunksCount;
  late final ChunksTable? chunksTable;

  late final Standard4BytesData<int> fallbackTableRelativeOffset;
  late final Standard4BytesData<bool> readData;
  late final DoubleByteData<int> unknownCount;
  late final DoubleByteData<int> additionalEffectsCount;
  late final DoubleByteData<int> chunksCountBeforeLinks;
  late final DoubleByteData<int> linksCount;
  late final Standard4BytesData<UnknowData> unknownData;
  late final Standard4BytesData<UnknowData> unknownData2;
  late final Standard4BytesData<int> unusedOffset;
  late final Standard4BytesData<int> pathFinderTableOffset;
  late final Standard4BytesData<int> pathFinderTableCount;
  late final BoundingBox boundingBox;
  // late final Standard4BytesData<double> boundingBoxMinX;
  // late final Standard4BytesData<double> boundingBoxMinY;
  // late final Standard4BytesData<double> boundingBoxMinZ;
  // late final Standard4BytesData<double> boundingBoxMaxX;
  // late final Standard4BytesData<double> boundingBoxMaxY;
  // late final Standard4BytesData<double> boundingBoxMaxZ;
  late final Standard4BytesData<int> animChunksTableHeaderOffset;
  late final Standard4BytesData<int> animObjectCount;

  @override
  String get label => name.value;

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
    readData = Standard4BytesData(
      position: fallbackTableRelativeOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownCount = DoubleByteData(
      relativePos: readData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    additionalEffectsCount = DoubleByteData(
      relativePos: unknownCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    chunksCountBeforeLinks = DoubleByteData(
      relativePos: additionalEffectsCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    linksCount = DoubleByteData(
      relativePos: chunksCountBeforeLinks.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownData = Standard4BytesData(
      position: linksCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unknownData2 = Standard4BytesData(
      position: unknownData.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    unusedOffset = Standard4BytesData(
      position: unknownData2.relativeEnd,
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
    final boundingBoxMinX = Standard4BytesData<double>(
      position: pathFinderTableCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    final boundingBoxMinY = Standard4BytesData<double>(
      position: boundingBoxMinX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    final boundingBoxMinZ = Standard4BytesData<double>(
      position: boundingBoxMinY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    final boundingBoxMaxX = Standard4BytesData<double>(
      position: boundingBoxMinZ.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    final boundingBoxMaxY = Standard4BytesData<double>(
      position: boundingBoxMaxX.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    final boundingBoxMaxZ = Standard4BytesData<double>(
      position: boundingBoxMaxY.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    boundingBox = BoundingBox(
      x: (
        min: boundingBoxMinX.value,
        max: boundingBoxMaxX.value,
      ),
      y: (
        min: boundingBoxMinY.value,
        max: boundingBoxMaxY.value,
      ),
      z: (
        min: boundingBoxMinZ.value,
        max: boundingBoxMaxZ.value,
      ),
    );
    animChunksTableHeaderOffset = Standard4BytesData(
      position: boundingBoxMaxZ.relativeEnd,
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

  @override
  String toString() {
    return 'ModelSettings: $name - $objectNameRelativeOffset - $chunksTableRelativeOffset - $chunksCount - $fallbackTableRelativeOffset - $readData - $unknownCount - $additionalEffectsCount - $chunksCountBeforeLinks - $linksCount - $unknownData - $unknownData2 - $unusedOffset - $pathFinderTableOffset - $pathFinderTableCount - $boundingBox - $animChunksTableHeaderOffset - $animObjectCount';
  }
}

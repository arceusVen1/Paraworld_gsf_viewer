import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/cloth.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/link.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/skeleton.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/fallback_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/materials_table.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/object_name.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/classes/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/providers/notifiers.dart';
import 'package:paraworld_gsf_viewer/providers/state.dart';

enum ModelType {
  char,
  ress,
  bldg,
  deko,
  vehi,
  fiel,
  misc,
  towe,
  anim,
  ship,
  vgtn,
  rivr,
  wall,
  unknown,
  none,
}

class ModelSettings extends GsfPart {
  late final GsfData<String> fourCC;
  late final ModelType type;
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
  String get label => "${fourCC.value} (${objectName.label})";

  ModelSettings.fromBytes(Uint8List bytes, int offset) : super(offset: offset) {
    fourCC = Standard4BytesData<String>(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    type = ModelType.values.firstWhere(
      (element) => element.name == fourCC.value.toLowerCase(),
    );
    // type = ModelType.values
    //         .where(
    //           (element) => element.name == fourCC.value.toLowerCase(),
    //         )
    //         .firstOrNull ??
    //     ModelType.unknown;
    objectNameRelativeOffset = Standard4BytesData(
      position: fourCC.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    objectName = ObjectName.fromBytes(
      bytes,
      offset +
          objectNameRelativeOffset.relativePos +
          objectNameRelativeOffset.value,
    );
    print(objectName.label);

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
    } else {
      chunksTable = null;
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

  Model toModel(
    MaterialsTable materialsTable,
    String? pwFolder,
    DetailTable? detailTable,
    PathGetter? getTexturePathFnct,
  ) {
    final List<ModelMesh> meshes = [];
    final List<ModelMesh> cloths = [];
    final List<SkeletonModel> skeletons = [];
    final List<LinkModel> links = [];
    final List<int> materialIndices =
        fallbackTable?.usedMaterialIndexes.map((e) => e.value).toList() ?? [];
    for (final chunk in chunksTable?.chunks ?? <Chunk>[]) {
      if (chunk.type == ChunkType.skeleton) {
        skeletons.add((chunk as SkeletonChunk).toModel());
      } else if (chunk.type.isLinkLike()) {
        links.add((chunk as LinkChunk).toModelVertex());
      } else if (chunk.type.isMeshLike()) {
        meshes.add((chunk as MeshChunk).toModelMesh(
          ChunkAttributes.fromValue(type, chunk.attributes.value),
          materialIndices,
          materialsTable.materials,
          pwFolder,
          detailTable,
          getTexturePathFnct,
        ));
      } else if (chunk.type.isClothLike()) {
        cloths.add((chunk as ClothChunk).toModelMesh(
          ChunkAttributes.fromValue(type, chunk.attributes.value),
          materialIndices,
          materialsTable.materials,
          pwFolder,
          detailTable,
          getTexturePathFnct,
        ));
      }
    }
    // assert(
    //   skeletons.length == skeletonChunksCount.value,
    //   'Skeletons count ${skeletonChunksCount.value} does not match ${skeletons.length}',
    // );
    return Model(
      name: objectName.label,
      type: type,
      meshes: meshes,
      cloth: cloths,
      boundingBox: boundingBox.toModelBox(),
      skeletons: skeletons,
      links: links,
    );
  }

  @override
  int getEndOffset() {
    return animObjectCount.offsettedLength;
  }
}

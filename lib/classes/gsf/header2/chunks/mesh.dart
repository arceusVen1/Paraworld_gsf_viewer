import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:paraworld_gsf_viewer/classes/gsf/header2/affine_matrix.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/bounding_box.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/chunk_attributes.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/chunks/submesh.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/material.dart';
import 'package:paraworld_gsf_viewer/classes/gsf/header2/model_settings.dart';
import 'package:paraworld_gsf_viewer/classes/gsf_data.dart';
import 'package:paraworld_gsf_viewer/classes/mesh.dart';
import 'package:paraworld_gsf_viewer/classes/model.dart';
import 'package:paraworld_gsf_viewer/classes/texture.dart';
import 'package:paraworld_gsf_viewer/providers/texture.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:ui' as ui;

mixin MeshToModelInterface on Chunk {
  BoundingBox get boundingBox;
  List<Submesh> get submeshes;
  List<DoubleByteData<int>> get materialIndices;
  Matrix4 get matrix;

  Future<ui.Image?> _getImage(
    String name,
    String pwFolder,
    DetailTable detailTable,
  ) async {
    try {
      String textureRealName = name.split("/").last.split(".").first;

      String pathToTexture = name.replaceAll("/$textureRealName.tga", "");
      if (detailTable[textureRealName] == null) {
        return null;
      }
      final int maxResolution =
          detailTable[textureRealName]!.availableResolutions.last;
      if (detailTable[textureRealName]!.overrideNameWithResolution) {
        textureRealName =
            "${textureRealName}_(${maxResolution > 1000 ? maxResolution : "0${maxResolution < 100 ? "0$maxResolution" : maxResolution}"}).dds";
      } else {
        textureRealName = name.split("/").last;
      }

      final texture =
          File('$pwFolder/Data/Base/Texture/$pathToTexture/$textureRealName');
      final completer = Completer<ui.Image>();
      final bytes = await texture.readAsBytes();
      ui.decodeImageFromList(bytes, completer.complete);
      return completer.future;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ModelMesh> toModelMesh(
    ChunkAttributes attributes, [
    List<int> fallbackMaterialIndices = const [],
    List<MaterialData> materialTable = const [],
    String? pwFolder,
    DetailTable? detailTable,
  ]) async {
    final List<ModelSubMesh> meshes = [];
    for (var submeshIndice = 0;
        submeshIndice < submeshes.length;
        submeshIndice++) {
      final submesh = submeshes[submeshIndice];
      final data = submesh.getMeshModelData(
        0,
        boundingBox.toModelBox(),
        matrix,
      );
      ui.Image? texture;
      if (pwFolder != null &&
          detailTable != null &&
          materialIndices.length > submeshIndice &&
          fallbackMaterialIndices.length >
              materialIndices[submeshIndice].value) {
        final textureName = materialTable[
                fallbackMaterialIndices[materialIndices[submeshIndice].value]]
            .textureName
            ?.trueName
            .value
            .value;
        if (textureName != null && textureName.isNotEmpty) {
          texture = await _getImage(textureName, pwFolder, detailTable);
        }
      }
      meshes.add(
        ModelSubMesh(
          vertices: data.vertices,
          triangles: data.triangles,
          texture: texture != null ? ModelTexture(texture) : null,
        ),
      );
    }
    return ModelMesh(
      submeshes: meshes,
      attributes: attributes,
    );
  }

  Future<Model> toModel() async {
    final globalBB = boundingBox.toModelBox();
    return Model(
      name: label,
      type: ModelType.none,
      meshes: [
        await toModelMesh(
          ChunkAttributes(
            value: attributes.value,
            typeOfModel: ModelType.unknown,
          ),
        )
      ],
      cloth: [],
      boundingBox: globalBB,
    );
  }
}

class MeshChunk extends Chunk with MeshToModelInterface {
  late final Standard4BytesData<int> guid;
  late final AffineTransformation transformation;
  late final Standard4BytesData<UnknowData> unknownData;
  late final Standard4BytesData<int>? skeletonIndex; // only for skinned mesh
  late final Standard4BytesData<UnknowData>?
      boneIds; // only for simple skinned mesh
  late final Standard4BytesData<UnknowData>?
      boneWeights; // only for simple skinned mesh
  late final Standard4BytesData<int> globalBoundingBoxOffset;
  late final Standard4BytesData<int> unknownId;
  @override
  late final BoundingBox boundingBox;
  late final Standard4BytesData<int> submeshInfoCount;
  late final Standard4BytesData<int> submeshInfoOffset;
  late final Standard4BytesData<int> submeshInfo2Count;
  late final Standard4BytesData<int> submeshMaterialsOffset;
  late final Standard4BytesData<int> submeshMaterialsCount;

  @override
  late final List<Submesh> submeshes;

  @override
  late final List<DoubleByteData<int>> materialIndices;

  @override
  Matrix4 get matrix => transformation.matrix;

  @override
  String get label => '${type.name} 0x${guid.value.toRadixString(16)}';

  MeshChunk.fromBytes(Uint8List bytes, int offset, ChunkType type)
      : super(offset: offset, type: type) {
    assert(type.isMeshLike(), "mesh can only of mesh like type");
    attributes = Standard4BytesData(
      position: 0,
      bytes: bytes,
      offset: offset,
    );
    guid = Standard4BytesData(
      position: attributes.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    transformation = AffineTransformation.fromBytes(
      bytes,
      guid.offsettedLength,
    );
    unknownData = Standard4BytesData(
      position: guid.relativeEnd + transformation.length,
      bytes: bytes,
      offset: offset,
    );

    int nextRelativePos = unknownData.relativeEnd;
    if (type.isSkinned()) {
      skeletonIndex = Standard4BytesData(
        position: nextRelativePos,
        bytes: bytes,
        offset: offset,
      );
      nextRelativePos = skeletonIndex!.relativeEnd;
    } else {
      skeletonIndex = null;
    }
    if (type == ChunkType.meshSkinnedSimple) {
      boneIds = Standard4BytesData(
        position: skeletonIndex!.relativeEnd,
        bytes: bytes,
        offset: offset,
      );
      boneWeights = Standard4BytesData(
        position: boneIds!.relativeEnd,
        bytes: bytes,
        offset: offset,
      );
      nextRelativePos = boneWeights!.relativeEnd;
    } else {
      boneIds = null;
      boneWeights = null;
    }

    globalBoundingBoxOffset = Standard4BytesData(
      position: nextRelativePos,
      bytes: bytes,
      offset: offset,
    );
    unknownId = Standard4BytesData(
      position: globalBoundingBoxOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    boundingBox = BoundingBox.fromBytes(
      bytes,
      globalBoundingBoxOffset.offsettedPos + globalBoundingBoxOffset.value,
    );
    submeshInfoCount = Standard4BytesData(
      position: boundingBox.getEndOffset() - offset,
      bytes: bytes,
      offset: offset,
    );
    submeshInfoOffset = Standard4BytesData(
      position: submeshInfoCount.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    submeshInfo2Count = Standard4BytesData(
      position: submeshInfoOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    submeshMaterialsOffset = Standard4BytesData(
      position: submeshInfo2Count.relativeEnd,
      bytes: bytes,
      offset: offset,
    );
    submeshMaterialsCount = Standard4BytesData(
      position: submeshMaterialsOffset.relativeEnd,
      bytes: bytes,
      offset: offset,
    );

    materialIndices = [];
    for (var i = 0; i < submeshMaterialsCount.value; i++) {
      final materialIndex = DoubleByteData<int>(
        relativePos: i * 2,
        bytes: bytes,
        offset:
            submeshMaterialsOffset.offsettedPos + submeshMaterialsOffset.value,
      );
      materialIndices.add(materialIndex);
    }

    submeshes = [];
    for (var i = 0; i < submeshInfoCount.value; i++) {
      final submesh = Submesh.fromBytes(
        bytes,
        submeshes.isNotEmpty
            ? submeshes.last.getEndOffset()
            : submeshInfoOffset.offsettedPos + submeshInfoOffset.value,
        false,
      );
      submeshes.add(submesh);
    }
  }

  @override
  int getEndOffset() {
    return submeshes.isNotEmpty
        ? submeshes.last.getEndOffset()
        : submeshMaterialsCount.offsettedLength;
  }
}

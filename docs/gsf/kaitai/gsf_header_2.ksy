meta:
  id: gsf_header_2
  file-extension: gsf
  application: ParaWorld
  license: CC0-1.0
  endian: le
seq:
  - id: zero
    contents: [0x00, 0x00, 0x00, 0x00]
  - id: num_models
    type: u4
  - id: num_anims
    type: u4
  - id: zero2
    contents: [0x00, 0x00, 0x00, 0x00]
  - id: model_settings_offset
    type: u4
  - id: num_model_settings
    type: u4
  - id: anim_settings_offset
    type: u4
  - id: num_anim_settings
    type: u4
  - id: structs
    type: materials_header
  - id: structs2
    type: model_settings
    repeat: expr
    repeat-expr: num_model_settings
  - id: structs3
    type: anim_settings
    repeat: expr
    repeat-expr: num_anim_settings
types:
  materials_header:
    seq:
      - id: num_material
        type: u4
      - id: materials_offset
        type: u4
      - id: num_max_entries
        type: u4
  model_settings:
    seq:
      - id: fourcc
        type: str
        size: 4
        encoding: ASCII
      - id: object_name_offset
        type: u4
      - id: chunks_table_offset
        type: u4
      - id: num_chunks
        type: u4
      - id: obj_table_cont_table_offset
        type: u4
      - id: read_data_true_false
        type: u4
      - id: num_unk
        type: u2
      - id: num_additional_effects
        type: u2
      - id: num_chunks_before_links
        type: u2
      - id: num_links
        type: u2
      - id: unk
        size: 4
      - id: unk2
        type: u4
      - id: unused_offset
        type: u4
      - id: pathfinder_table_offset
        type: u4
      - id: num_pathfinder_tables
        type: u4
      - id: bbox_min_x
        type: f4
      - id: bbox_min_y
        type: f4
      - id: bbox_min_z
        type: f4
      - id: bbox_max_x
        type: f4
      - id: bbox_max_y
        type: f4
      - id: bbox_max_z
        type: f4
      - id: anim_attr_table_offset
        type: u4
      - id: num_object_anim
        type: u4
  anim_settings:
    seq:
      - id: fourcc
        type: str
        size: 4
        encoding: ASCII
      - id: anim_header_offset
        type: u4
      - id: anim_start_pointer_offset
        type: u4
      - id: num_anim_start_pointer_offsets
        type: u4
      - id: stand_pos_obj_offset
        type: u4
      - id: num_stand_pos_obj_offsets
        type: u4
      - id: num_frames
        type: u4
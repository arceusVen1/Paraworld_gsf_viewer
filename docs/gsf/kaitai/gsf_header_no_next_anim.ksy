meta:
  id: graphic_set_file
  file-extension: gsf
  application: ParaWorld
  license: CC0-1.0
  endian: le
seq:
  - id: magic
    contents: [0x47, 0x53, 0x46, 0x00]
  - id: version
    type: u4
  - id: header2_struct_offset
    type: u4
  - id: num_chars
    type: u4
  - id: file_name
    type: str
    size: num_chars
    encoding: ASCII
  - id: num_models
    type: u4
  - id: structs
    type: model_info
    repeat: expr
    repeat-expr: num_models
  - id: structs2
    type: sound_table
  - id: structs3
    type: dusttrail_table
  - id: structs4
    type: walk_transition_table
  - id: structs5
    type: walk_transition_table2
types:
  model_info:
    seq:
      - id: num_chars
        type: u4
      - id: model_name
        type: str
        size: num_chars
        encoding: ASCII
      - id: model_index
        type: u4
      - id: num_model_anim
        type: u4
      - id: structs
        type: model_anim
        repeat: expr
        repeat-expr: num_model_anim
        if: num_model_anim != 0
      - id: num_walksets
        type: u4
      - id: structs2
        type: walkset
        repeat: expr
        repeat-expr: num_walksets
        if: num_walksets != 0
  #Merge model_anim & model_anim_next
  model_anim:
    seq:
      - id: num_chars
        type: u4
      - id: model_anim_name
        type: str
        size: num_chars
        encoding: ASCII
      - id: anim_index
        type: u4
      - id: structs
        type: sound_indices_table
      - id: unk_bytes
        type: u4
  sound_indices_table:
    seq:
      - id: num_sound_indices
        type: u4
      - id: sound_indices
        type: u4
        repeat: expr
        repeat-expr: num_sound_indices
  walkset:
    seq:
      - id: walk_1
        type: u1
      - id: walk_2
        type: u1
      - id: walk_3
        type: u1
      - id: walk_4
        type: u1
      - id: walk_1_end_s
        type: u1
      - id: walk_1_end_m
        type: u1
      - id: walk_1_end_l
        type: u1
      - id: walk_2_end_s
        type: u1
      - id: walk_2_end_m
        type: u1
      - id: walk_2_end_l
        type: u1
      - id: walk_3_end_s
        type: u1
      - id: walk_3_end_m
        type: u1
      - id: walk_3_end_l
        type: u1
      - id: walk_4_end_s
        type: u1
      - id: walk_4_end_m
        type: u1
      - id: walk_4_end_l
        type: u1
      - id: standing_turn_right
        type: u1
      - id: standing_turn_left
        type: u1
      - id: unk_byte
        # contents: [0x00]
        # all_characters.gsf
        type: u1
      - id: accel_1_2
        type: u1
      - id: accel_2_3
        type: u1
      - id: accel_3_4
        type: u1
      - id: brake_4_3
        type: u1
      - id: brake_3_2
        type: u1
      - id: brake_2_1
        type: u1
      - id: walk_left
        type: u1
      - id: walk_right
        type: u1
      - id: unk_byte2
        # contents: [0x00]
        # all_characters.gsf
        type: u1
      - id: walk_transition_index
        type: u1
      - id: growup
        type: u1
      - id: sail_up
        type: u1
      - id: sail_down
        type: u1
      - id: standanim
        type: u1
      - id: walk_to_swim_2
        type: u1
      - id: unk_bytes
        # contents: [0x00, 0x00, 0x00, 0x00]
        # all_characters.gsf
        type: u4
      - id: unk_bytes2
        # contents: [0x00, 0x00, 0x00, 0x00]
        # all_characters.gsf
        type: u4
      - id: walkset_name
        type: str
        size: 4
        encoding: ASCII
  sound_table:
    seq:
      - id: num_sounds
        type: u4
      - id: structs
        type: sound
        repeat: expr
        repeat-expr: num_sounds
  sound:
    seq:
      - id: num_chars
        type: u4
      - id: sound_name
        type: str
        size: num_chars
        encoding: ASCII
      - id: start_frame
        type: u4
      - id: volume
        type: u4
      - id: speed
        type: f4
      - id: unk_bytes
        size: 16
      - id: num_snd_group_chars
        type: u4
      - id: snd_group_name
        type: str
        size: num_snd_group_chars
        encoding: ASCII
  dusttrail_table:
    seq:
    - id: num_dusttrail
      type: u4
    - id: structs
      type: dusttrail
      repeat: expr
      repeat-expr: num_dusttrail
  dusttrail:
    seq:
      - id: unk_bytes
        type: u4
      - id: unk_bytes2
        type: u2
      - id: dusttrail_name_num_chars
        type: u4
      - id: dusttrail_name
        type: str
        size: dusttrail_name_num_chars
        encoding: ASCII
      - id: unk_bytes_bone_index
        type: u4
      - id: num_entries
        type: u4
      - id: structs
        type: dusttrail_entry
        repeat: expr
        repeat-expr: num_entries
  dusttrail_entry:
    seq:
      - id: entry_name_num_chars
        type: u4
      - id: entry_name
        type: str
        size: entry_name_num_chars
        encoding: ASCII
      - id: value_num_chars
        type: u4
      - id: value
        type: str
        size: value_num_chars
        encoding: ASCII
  walk_transition_table:
    seq:
      - id: num_walk_transitions
        type: u4
      - id: structs
        type: walk_transition
        repeat: expr
        repeat-expr: num_walk_transitions
  walk_transition:
    seq:
      - id: num_chars
        type: u4
      - id: walk_transition_name
        type: str
        size: num_chars
        encoding: ASCII
  walk_transition_table2:
    seq:
      - id: num_walk_transitions
        type: u4
      - id: structs
        type: walk_transition2
        repeat: expr
        repeat-expr: num_walk_transitions
  walk_transition2:
    seq:
      - id: num_chars
        type: u4
      - id: walk_transition_name
        type: str
        size: num_chars
        encoding: ASCII
meta:
  id: gsf
  file-extension: gsf
  application: ParaWorld
  license: CC0-1.0
  endian: le
seq:
  - id: magic
    contents: [0x47, 0x53, 0x46, 0x00]
  - id: version
    contents: [0x00, 0x00, 0x00, 0x00]
  - id: header2_offset
    type: u4
  - id: header
    type: header
  - id: padding
    size: header2_offset - _io.pos
instances:
  header2:
    pos: header2_offset
    type: header2
types:
  header:
    seq:
      - id: num_chars
        type: u4
      - id: file_name
        type: str
        size: num_chars
        encoding: ASCII
      - id: num_models
        type: u4
      - id: model_info_table
        type: model_info_table
        repeat: expr
        repeat-expr: num_models
      - id: num_sounds
        type: u4
      - id: sound_table
        type: sound_table
        repeat: expr
        repeat-expr: num_sounds
      - id: num_dusttrails
        type: u4
      - id: dusttrail_table
        type: dusttrail_table
        repeat: expr
        repeat-expr: num_dusttrails
      - id: num_anim_flags
        type: u4
      - id: anim_flags_table
        type: anim_flags_table
        repeat: expr
        repeat-expr: num_anim_flags
      - id: num_walk_transitions
        type: u4
      - id: walk_transition_table
        type: walk_transition_table
        repeat: expr
        repeat-expr: num_walk_transitions
  header2:
    seq:
      - id: zero
        contents: [0x00, 0x00, 0x00, 0x00]
      - id: num_models2
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
      - id: materials_header
        type: materials_header
    instances:
      model_settings:
        pos: model_settings_offset + _io.pos + 16
        type: model_settings(_io.pos)
        size: 84
        repeat: expr
        repeat-expr: num_model_settings
        if: model_settings_offset != 0x80000000
      anim_settings:
        pos: anim_settings_offset + _io.pos + 24
        type: anim_settings(_io.pos)
        size: 28
        repeat: expr
        repeat-expr: num_anim_settings
        if: anim_settings_offset != 0x80000000
  model_info_table:
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
      - id: model_anim
        type: model_anim
        repeat: expr
        repeat-expr: num_model_anim
        if: num_model_anim != 0
      - id: num_walksets
        type: u4
      - id: walkset
        type: walkset
        repeat: expr
        repeat-expr: num_walksets
        if: num_walksets != 0
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
      - id: num_sound_indices
        type: u4
      - id: sound_indices
        type: u4
        repeat: expr
        repeat-expr: num_sound_indices
      - id: unk_idle_mgr
        type: u4
        #1 = idle anim
        #2 = walk anim?
  walkset:
    seq:
      - id: walk_1_anim_index
        type: u1
      - id: walk_2_anim_index
        type: u1
      - id: walk_3_anim_index
        type: u1
      - id: walk_4_anim_index
        type: u1
      - id: walk_1_end_s_anim_index
        type: u1
      - id: walk_1_end_m_anim_index
        type: u1
      - id: walk_1_end_l_anim_index
        type: u1
      - id: walk_2_end_s_anim_index
        type: u1
      - id: walk_2_end_m_anim_index
        type: u1
      - id: walk_2_end_l_anim_index
        type: u1
      - id: walk_3_end_s_anim_index
        type: u1
      - id: walk_3_end_m_anim_index
        type: u1
      - id: walk_3_end_l_anim_index
        type: u1
      - id: walk_4_end_s_anim_index
        type: u1
      - id: walk_4_end_m_anim_index
        type: u1
      - id: walk_4_end_l_anim_index
        type: u1
      - id: standing_turn_right_anim_index
        type: u1
      - id: standing_turn_left_anim_index
        type: u1
      - id: unk_anim_index
        # all_characters.gsf
        type: u1
      - id: accel_1_2_anim_index
        type: u1
      - id: accel_2_3_anim_index
        type: u1
      - id: accel_3_4_anim_index
        type: u1
      - id: brake_4_3_anim_index
        type: u1
      - id: brake_3_2_anim_index
        type: u1
      - id: brake_2_1_anim_index
        type: u1
      - id: walk_left_anim_index
        type: u1
      - id: walk_right_anim_index
        type: u1
      - id: unk_anim_index2
        # all_characters.gsf
        type: u1
      - id: walk_transition_index
        type: u1
      - id: growup_anim_index
        type: u1
      - id: sail_up_anim_index
        type: u1
      - id: sail_down_anim_index
        type: u1
      - id: standanim_anim_index
        type: u1
      - id: walk_to_swim_2_anim_index
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
      - id: model_info_index
        type: u4
      - id: unk_bytes
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
      - id: dusttrail_entry
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
  anim_flags_table:
    seq:
      - id: num_chars
        type: u4
      - id: anim_flag
        type: str
        size: num_chars
        encoding: ASCII
  walk_transition_table:
    seq:
      - id: num_chars
        type: u4
      - id: walk_transition_name
        type: str
        size: num_chars
        encoding: ASCII
  materials_header:
    seq:
      - id: num_material
        type: u4
      - id: materials_offset
        type: u4
      - id: num_max_entries
        type: u4
    instances:
      materials:
        pos: materials_offset + _io.pos + 36
        type: material(_io.pos)
        repeat: expr
        repeat-expr: num_max_entries
        if: materials_offset != 0x80000000
  material:
    params:
      - id: pos
        type: s4
    seq:
      - id: bitset_material_attributes1
        size: 4
      - id: bitset_material_attributes2
        size: 4
      - id: texture_name_offset
        type: u4
      - id: nm_name_offset
        type: u4
      - id: env_name_offset
        type: u4
      - id: zero
        contents: [0x00, 0x00, 0x00, 0x00]
    instances:
      texture_name:
        io: _root._io
        pos: pos + texture_name_offset + 8
        type: texture_name
        if: texture_name_offset != 0x80000000
      nm_name:
        io: _root._io
        pos: pos + nm_name_offset + 12
        type: nm_name
        if: nm_name_offset != 0x80000000
      env_name:
        io: _root._io
        pos: pos + env_name_offset + 16
        type: env_name
        if: env_name_offset != 0x80000000
  texture_name:
    seq:
      - id: num_strings
        type: u4
      - id: num_max_chars
        type: u4
      - id: num_chars
        type: u4
      - id: texture_name
        type: str
        size: num_chars
        encoding: ASCII
      - id: padding
        size: num_max_chars - num_chars
  nm_name:
    seq:
      - id: num_strings
        type: u4
      - id: num_max_chars
        type: u4
      - id: num_chars
        type: u4
      - id: nm_name
        type: str
        size: num_chars
        encoding: ASCII
      - id: padding
        size: num_max_chars - num_chars
  env_name:
    seq:
      - id: num_strings
        type: u4
      - id: num_max_chars
        type: u4
      - id: num_chars
        type: u4
      - id: env_name
        type: str
        size: num_chars
        encoding: ASCII
      - id: padding
        size: num_max_chars - num_chars
  model_settings:
    params:
      - id: pos
        type: s4
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
      - id: fallback_table_offset
        type: u4
      - id: read_data_true_false
        type: u4
      - id: model_settings_num_unk
        type: u2
      - id: num_additional_effects
        type: u2
      - id: num_chunks_before_links
        type: u2
      - id: num_links
        type: u2
      - id: model_settings_unk
        type: u4
      - id: model_settings_unk2
        type: u4
      - id: unused_offset
        contents: [0x00, 0x00, 0x00, 0x80]
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
      - id: anim_chunks_table_header_offset
        type: u4
      - id: num_object_anim
        type: u4
    instances:
      object_name:
        io: _root._io
        pos: pos + object_name_offset - 80
        type: object_name
        if: object_name_offset != 0x80000000
      chunks_table:
        io: _root._io
        pos: pos + chunks_table_offset - 76
        type: chunk_neg_offset(_io.pos, _index)
        repeat: expr
        repeat-expr: num_chunks
        if: chunks_table_offset != 0x80000000
      fallback_table:
        io: _root._io
        pos: pos + fallback_table_offset - 68
        type: fallback_table
        if: fallback_table_offset != 0x80000000
      pathfinder_table:
        io: _root._io
        pos: pos + pathfinder_table_offset - 40
        type: pathfinder_table
        repeat: expr
        repeat-expr: num_pathfinder_tables
        if: pathfinder_table_offset != 0x80000000
      anim_attr_table:
        io: _root._io
        pos: pos + anim_chunks_table_header_offset - 8
        type: anim_chunks_table_header(_io.pos, _index)
        repeat: expr
        repeat-expr: num_object_anim
        if: anim_chunks_table_header_offset != 0x80000000
  object_name:
    seq:
      - id: num_strings
        type: u4
      - id: num_max_chars
        type: u4
      - id: num_chars
        type: u4
      - id: object_name
        type: str
        size: num_chars
        encoding: ASCII
      - id: padding
        size: num_max_chars - num_chars
  chunk_neg_offset:
    params:
      - id: pos
        type: s4
      - id: i
        type: s4
    seq:
      - id: chunk_neg_offset
        type: s4
    instances:
      chunk:
        #wip pos is working but ugly
        io: _root._io
        pos: _parent.chunks_table_offset + _parent.pos + pos + chunk_neg_offset - 160 + i*4
        type: chunk
  chunk:
    seq:
      - id: chunk_type_enum
        type: u4
        enum: mesh_chunk_type
      - id: chunk_info
        type:
          switch-on: chunk_type_enum
          cases:
            mesh_chunk_type::mesh: mesh_chunk(_io.pos)
            mesh_chunk_type::billboard: billboard_chunk(_io.pos)
            #mesh_chunk_type::particle: particle_chunk
            mesh_chunk_type::skeleton: skeleton_chunk(_io.pos)
            mesh_chunk_type::cloth: cloth_chunk(_io.pos)
            mesh_chunk_type::phys_coll: phys_coll_chunk
            mesh_chunk_type::pos_link: pos_link_chunk
            mesh_chunk_type::sound_sphere: sound_sphere_chunk
            mesh_chunk_type::speedline: speedline_chunk
            #Skinned chunks:
            mesh_chunk_type::mesh_skinned: mesh_skinned_chunk(_io.pos)
            mesh_chunk_type::billboard_skinned: billboard_skinned_chunk
            mesh_chunk_type::particle_skinned: particle_skinned_chunk
            mesh_chunk_type::skeleton_skinned: skeleton_skinned_chunk
            mesh_chunk_type::cloth_skinned: cloth_skinned_chunk
            mesh_chunk_type::phys_coll_skinned: phys_coll_skinned_chunk
            mesh_chunk_type::bone_link: bone_link_chunk
            mesh_chunk_type::sound_sphere_skinned: sound_sphere_skinned_chunk
            mesh_chunk_type::speedline_skinned: speedline_skinned_chunk	
  sound_sphere_chunk:
    seq:
      - id: unk
        type: u4
      - id: unk1
        type: u4
      - id: num_unk
        type: u4
      - id: unk_float
        type: f4
      - id: unk_float1
        type: f4
      - id: unk_float2
        type: f4
      - id: unk_float3
        type: f4
      - id: unk_float4
        type: f4
      - id: unk_float5
        type: f4
  pos_link_chunk:
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: guat_1
        type: f4
      - id: guat_i
        type: f4
      - id: guat_j
        type: f4
      - id: guat_k
        type: f4
      - id: link_fourcc
        type: str
        size: 4
        encoding: ASCII
  bone_link_chunk:
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: guat_1
        type: f4
      - id: guat_i
        type: f4
      - id: guat_j
        type: f4
      - id: guat_k
        type: f4
      - id: link_fourcc
        type: str
        size: 4
        encoding: ASCII
      - id: unk
        type: u4
        #hu_products.gsf
        #contents: [0x00, 0x00, 0x00, 0x00]
      - id: bone_id
        type: u4
      - id: bone_weight
        type: u4
  skeleton_chunk:
    params:
      - id: pos
        type: s4
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: skeleton_index
        type: u4
      - id: skeleton_guid
        type: u4
      - id: flags
        type: u4
      - id: anim_pos_x
        type: f4
      - id: anim_pos_y
        type: f4
      - id: anim_pos_z
        type: f4
      - id: scale_x
        type: f4
      - id: scale_y
        type: f4
      - id: scale_z
        type: f4
      - id: guat_1
        type: f4
      - id: guat_i
        type: f4
      - id: guat_j
        type: f4
      - id: guat_k
        type: f4
      - id: bones_count1
        type: u4
      - id: next_bone_offset
        type: u4
      - id: bones_count2
        type: u4
      - id: bind_pose_offset
        type: u4
      - id: num_all_bones
        type: u4
      - id: num_all_bones2
        type: u4
      - id: num_unk2
        type: u4
      - id: bone
        type: bone_chunk
        repeat: expr
        repeat-expr: num_all_bones - 1
    instances:
      bind_pose_chunk:
        io: _root._io
        #pos: _parent.anim_chunks_table_header_offset - 88 + _parent.pos + pos + anim_chunks_table_offset + i*12
        pos: pos + bind_pose_offset + 72
        type: bind_pose_chunk
        repeat: expr
        repeat-expr: num_all_bones
        if: bind_pose_offset != 0x80000000
  bone_chunk:
    seq:
      - id: guid
        type: u4
      - id: flags
        type: u4
      - id: anim_pos_x
        type: f4
      - id: anim_pos_y
        type: f4
      - id: anim_pos_z
        type: f4
      - id: scale_x
        type: f4
      - id: scale_y
        type: f4
      - id: scale_z
        type: f4
      - id: guat_1
        type: f4
      - id: guat_i
        type: f4
      - id: guat_j
        type: f4
      - id: guat_k
        type: f4
      - id: bones_count1
        type: u4
      - id: next_bone_offset
        type: u4
      - id: bones_count2
        type: u4
  bind_pose_chunk:
    seq:
      - id: float1_1
        type: f4
      - id: float1_2
        type: f4
      - id: float1_3
        type: f4
      - id: float1_4
        type: f4
      - id: float2_1
        type: f4
      - id: float2_2
        type: f4
      - id: float2_3
        type: f4
      - id: float2_4
        type: f4
      - id: float3_1
        type: f4
      - id: float3_2
        type: f4
      - id: float3_3
        type: f4
      - id: float3_4
        type: f4
      - id: float4_1
        type: f4
      - id: float4_2
        type: f4
      - id: float4_3
        type: f4
      - id: float4_4
        type: f4
  mesh_chunk:
    params:
      - id: pos
        type: s4
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: scale_x
        type: f4
      - id: stretch_y
        type: f4
      - id: stretch_z_x
        type: f4
      - id: float_1
        type: f4
      - id: stretch_x
        type: f4
      - id: scale_y
        type: f4
      - id: stretch_z_y
        type: f4
      - id: float_2
        type: f4
      - id: shear_x
        type: f4
      - id: shear_y
        type: f4
      - id: scale_z
        type: f4
      - id: float_3
        type: f4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: float_4
        type: f4
      - id: mesh_chunk_unk
        type: u4
      - id: global_bbox_offset
        type: u4
      - id: mesh_chunk_unk1
        type: u4
      - id: global_bbox_min_x
        type: f4
      - id: global_bbox_min_y
        type: f4
      - id: global_bbox_min_z
        type: f4
      - id: global_bbox_max_x
        type: f4
      - id: global_bbox_max_y
        type: f4
      - id: global_bbox_max_z
        type: f4
      - id: num_submesh_info
        type: u4
      - id: submesh_info_offset
        type: u4
      - id: num_submesh_info2
        type: u4
      - id: submesh_materials_offset
        type: u4
      - id: num_submesh_materials
        type: u4
      - id: submesh_info
        type: submesh_info(_io.pos)
        repeat: expr
        repeat-expr: num_submesh_info
    instances:
      submesh_materials:
        io: _root._io
        pos: pos + submesh_materials_offset + 120
        type: u2
        repeat: expr
        repeat-expr: num_submesh_materials
        if: submesh_materials_offset != 0x80000000
  submesh_info:
    params:
      - id: pos
        type: s4
    seq:
      - id: local_bbox_min_x
        type: f4
      - id: local_bbox_min_y
        type: f4
      - id: local_bbox_min_z
        type: f4
      - id: local_bbox_max_x
        type: f4
      - id: local_bbox_max_y
        type: f4
      - id: local_bbox_max_z
        type: f4
      - id: num_vertices
        type: u4
      - id: num_triangles
        type: u4
      - id: vertices_offset
        type: u4
      - id: triangles_offset
        type: u4
      - id: num_triangles2
        type: u4
      - id: vertex_type
        type: u4
      - id: light_data_offset
        type: u4
      - id: num_light_data
        type: u4
    instances:
      vertices_data:
        io: _root._io
        pos: pos + vertices_offset + 32
        size: num_vertices * vertex_type
        if: vertices_offset != 0x80000000
      triangles_data:
        io: _root._io
        pos: pos + triangles_offset + 36
        size: num_triangles * 6
        if: triangles_offset != 0x80000000
      light_data:
        io: _root._io
        pos: pos + light_data_offset + 48
        type: u2
        repeat: expr
        repeat-expr: num_vertices
        if: light_data_offset != 0x80000000
  mesh_skinned_chunk:
    params:
      - id: pos
        type: s4
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: scale_x
        type: f4
      - id: stretch_y
        type: f4
      - id: stretch_z_x
        type: f4
      - id: float_1
        type: f4
      - id: stretch_x
        type: f4
      - id: scale_y
        type: f4
      - id: stretch_z_y
        type: f4
      - id: float_2
        type: f4
      - id: shear_x
        type: f4
      - id: shear_y
        type: f4
      - id: scale_z
        type: f4
      - id: float_3
        type: f4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: float_4
        type: f4
      - id: mesh_chunk_unk
        type: u4
      - id: skeleton_index
        type: u4
      - id: global_bbox_offset
        type: u4
      - id: mesh_chunk_unk1
        type: u4
      - id: global_bbox_min_x
        type: f4
      - id: global_bbox_min_y
        type: f4
      - id: global_bbox_min_z
        type: f4
      - id: global_bbox_max_x
        type: f4
      - id: global_bbox_max_y
        type: f4
      - id: global_bbox_max_z
        type: f4
      - id: num_submesh_info
        type: u4
      - id: submesh_info_offset
        type: u4
      - id: num_submesh_info2
        type: u4
      - id: submesh_materials_offset
        type: u4
      - id: num_submesh_materials
        type: u4
      - id: submesh_info
        type: submesh_info(_io.pos)
        repeat: expr
        repeat-expr: num_submesh_info
    instances:
      submesh_materials:
        io: _root._io
        pos: pos + submesh_materials_offset + 124
        type: u2
        repeat: expr
        repeat-expr: num_submesh_materials
        if: submesh_materials_offset != 0x80000000
  cloth_chunk:
    params:
      - id: pos
        type: s4
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: scale_x
        type: f4
      - id: stretch_y
        type: f4
      - id: stretch_z_x
        type: f4
      - id: float_1
        type: f4
      - id: stretch_x
        type: f4
      - id: scale_y
        type: f4
      - id: stretch_z_y
        type: f4
      - id: float_2
        type: f4
      - id: shear_x
        type: f4
      - id: shear_y
        type: f4
      - id: scale_z
        type: f4
      - id: float_3
        type: f4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: float_4
        type: f4
      - id: mesh_chunk_unk
        type: u4
      - id: global_bbox_offset
        type: u4
      - id: mesh_chunk_unk1
        type: u4
      - id: cloth_unk_offset
        type: u4
      - id: cloth_num_unk1
        type: u4
      - id: cloth_unk_offset1
        type: u4
      - id: cloth_num_unk2
        type: u4
      - id: cloth_unk_offset2
        type: u4
      - id: cloth_num_unk3
        type: u4
      - id: cloth_unk_offset3
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
      - id: num_submesh_info
        type: u4
      - id: submesh_info_offset
        type: u4
      - id: num_submesh_info2
        type: u4
      - id: submesh_materials_offset
        type: u4
      - id: num_submesh_materials
        type: u4
      - id: cloth_submesh_info
        type: cloth_submesh_info(_io.pos)
        repeat: expr
        repeat-expr: num_submesh_info
    instances:
      submesh_materials:
        io: _root._io
        pos: pos + submesh_materials_offset + 148
        type: u2
        repeat: expr
        repeat-expr: num_submesh_materials
        if: submesh_materials_offset != 0x80000000
  cloth_submesh_info:
    params:
      - id: pos
        type: s4
    seq:
      - id: local_bbox_min_x
        type: f4
      - id: local_bbox_min_y
        type: f4
      - id: local_bbox_min_z
        type: f4
      - id: local_bbox_max_x
        type: f4
      - id: local_bbox_max_y
        type: f4
      - id: local_bbox_max_z
        type: f4
      - id: num_vertices
        type: u4
      - id: num_triangles
        type: u4
        #PestGfx.GfxObjRenderer ERROR:Cloth Component 2 in Object: flyingtrader has 0 chunks (should be 1)!
      - id: cloth_sim_unk
        type: u4
      - id: vertices_offset
        type: u4
      - id: triangles_offset
        type: u4
      - id: num_triangles2
        type: u4
      - id: light_data_offset
        type: u4
      - id: num_light_data
        type: u4
      - id: vertex_type
        type: u4
    instances:
      vertices_data:
        io: _root._io
        pos: pos + vertices_offset + 36
        size: num_vertices * vertex_type
        if: vertices_offset != 0x80000000
      triangles_data:
        io: _root._io
        pos: pos + triangles_offset + 40
        size: num_triangles * 6
        if: triangles_offset != 0x80000000
      light_data:
        io: _root._io
        pos: pos + light_data_offset + 48
        type: u2
        repeat: expr
        repeat-expr: num_vertices
        if: light_data_offset != 0x80000000
  particle_chunk:
    seq:
      - id: attribs
        type: u4
      - id: guid
        type: u4
      - id: unk
        size: 8
      - id: unk_float
        type: f4
      - id: unk2
        size: 16
      - id: unk_float2
        type: f4
      - id: unk_float3
        type: f4
      - id: unk_float4
        type: f4
      - id: spread
        type: f4
      - id: num_unk
        type: u4
      - id: unk_float5
        type: f4
      - id: num_unk2
        type: u4
      - id: num_unk3
        type: u4
      - id: num_unk4
        type: u4
      - id: num_unk5
        type: u4
      - id: num_unk6
        type: u4
      - id: num_strings
        type: u4
      - id: num_max_chars
        type: u4
      - id: num_chars_bugged
        type: u4
      - id: particle_name
        type: str
        size: num_max_chars
        encoding: ASCII
      - id: unk_atlas_stuff
        size: 4
      - id: unk5
        size: 5
      - id: particle_size
        type: f4
      - id: particle_speed
        type: f4
      - id: unk_float6
        type: f4
      - id: unk_float7
        type: f4
      - id: unk_float8
        type: f4
      - id: unk_float9
        type: f4
      - id: unk6
        size: 4
      - id: color_fade_out_speed
        type: f4
      - id: color_fade_in_speed
        type: f4
      - id: emitter_speed
        type: f4
      - id: scale
        type: f4
      - id: particle_scale
        type: f4
      - id: red_rnd_mul
        type: u4
      - id: green_rnd_mul
        type: u4
      - id: blue_rnd_mul
        type: u4
      - id: red_mul
        type: f4
      - id: green_mul
        type: f4
      - id: blue_mul
        type: f4
      - id: red_strength
        type: u4
      - id: green_strength
        type: u4
      - id: blue_strength
        type: u4
      - id: unk7
        size: 12
      - id: unk_float10
        type: f4
      - id: unk9
        size: 16
  billboard_chunk:
    params:
      - id: pos
        type: s4
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: scale_x
        type: f4
      - id: stretch_y
        type: f4
      - id: stretch_z_x
        type: f4
      - id: float_1
        type: f4
      - id: stretch_x
        type: f4
      - id: scale_y
        type: f4
      - id: stretch_z_y
        type: f4
      - id: float_2
        type: f4
      - id: shear_x
        type: f4
      - id: shear_y
        type: f4
      - id: scale_z
        type: f4
      - id: float_3
        type: f4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: float_4
        type: f4
      - id: mesh_chunk_unk
        type: u4
      - id: unk
        size: 48
      - id: num_vertices
        type: u4
      - id: vertices_offset
        type: u4
      - id: vertex_type
        type: u4
    instances:
      vertices_data:
        io: _root._io
        pos: pos + vertices_offset + 128
        size: num_vertices * vertex_type
        if: vertices_offset != 0x80000000
  phys_coll_chunk:
    seq:
      - id: unk
        type: u4
  speedline_chunk:
    seq:
      - id: unk
        type: u4
  billboard_skinned_chunk:
    seq:
      - id: unk
        type: u4
  particle_skinned_chunk:
    seq:
      - id: unk
        type: u4
  skeleton_skinned_chunk:
    seq:
      - id: unk
        type: u4	
  cloth_skinned_chunk:
    seq:
      - id: unk
        type: u4	
  phys_coll_skinned_chunk:
    seq:
      - id: unk
        type: u4
  sound_sphere_skinned_chunk:
    seq:
      - id: unk
        type: u4
  speedline_skinned_chunk:
    seq:
      - id: unk
        type: u4
  fallback_table:
    seq:
      - id: header2_neg_offset
        type: u4
      - id: model_settings_neg_offset
        type: u4
      - id: num_unk
        type: u4
      - id: num_used_materials
        type: u4
      - id: num_unk2
        type: u4
      - id: used_material_index
        type: u4
        repeat: expr
        repeat-expr: num_used_materials
  pathfinder_table:
    seq:
      - id: pathfinder_enum
        type: u4
        enum: pf_type
      - id: pathfinder
        type:
          switch-on: pathfinder_enum
          cases:
            pf_type::hit_collision: hit_collision_struct
            pf_type::path_blocker: path_blocker_struct
  hit_collision_struct:
    seq:
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: sphere_size
        type: f4
      - id: guid
        type: f4
      - id: zero
        contents: [0x00, 0x00, 0x00, 0x00]
      - id: unk
        type: u4
  path_blocker_struct:
    seq:
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: size_x
        type: f4
      - id: size_y
        type: f4
      - id: size_z
        type: f4
      - id: unk
        type: u4
  anim_chunks_table_header:
    params:
      - id: pos
        type: s4
      - id: i
        type: s4
    seq:
      - id: model_settings_neg_offset
        type: u4
      - id: anim_chunks_table_offset
        type: u4
      - id: num_offsets
        type: u4
    instances:
      anim_chunks_table:
        #wip pos is working but ugly
        io: _root._io
        pos: _parent.anim_chunks_table_header_offset - 88 + _parent.pos + pos + anim_chunks_table_offset + i*12
        type: anim_chunks_table
        repeat: expr
        repeat-expr: num_offsets
        if: anim_chunks_table_offset != 0x80000000
  anim_chunks_table:
    seq:
      - id: anim_chunk_neg_offset
        type: u4
      - id: num_anim_frames
        type: u4
  anim_settings:
    params:
      - id: pos
        type: s4
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
    instances:
      anim_header:
        io: _root._io
        pos: pos + anim_header_offset - 24
        type: anim_header
        if: anim_header_offset != 0x80000000
      anim_start_pointer:
        io: _root._io
        pos: pos + anim_start_pointer_offset - 20
        type: anim_start_neg_offset
        repeat: expr
        repeat-expr: num_anim_start_pointer_offsets
        if: anim_start_pointer_offset != 0x80000000
      stand_pos_obj:
        io: _root._io
        pos: pos + stand_pos_obj_offset - 12
        type: stand_pos_obj(_io.pos)
        repeat: expr
        repeat-expr: num_stand_pos_obj_offsets
        if: stand_pos_obj_offset != 0x80000000
  anim_header:
    seq:
      - id: num_strings
        type: u4
      - id: num_max_chars
        type: u4
      - id: num_chars
        type: u4
      - id: anim_name
        type: str
        size: num_chars
        encoding: ASCII
      - id: padding
        size: num_max_chars - num_chars
  anim_start_neg_offset:
    seq:
      - id: anim_start_neg_offset
        type: u4
  stand_pos_obj:
    params:
      - id: pos
        type: s4
    seq:
      - id: header2_neg_offset
        type: u4
      - id: materials_header_neg_offset
        type: u4
      - id: anim_texture_table_offset
        type: u4
      - id: unk1
        type: u4
      - id: unk2
        type: u4
      - id: chunk_type
        type: u4
      - id: attributes
        type: u4
      - id: guid
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
    instances:
      anim_texture_table:
        io: _root._io
        pos: pos + anim_texture_table_offset + 48
        type: anim_texture_table
        if: anim_texture_table_offset != 0x80000000
  anim_texture_table:
    seq:
      - id: unk_wip
        type: u4
enums:
  pf_type:
    0x00000000: hit_collision
    0x00000001: path_blocker
  mesh_chunk_type:
    0x00000000: mesh
    0x00000001: billboard
    0x00000002: particle
    0x00000005: skeleton
    0x00000009: cloth
    0x0000000A: phys_coll
    0x0000000B: pos_link
    0x0000000D: sound_sphere
    0x0000000E: speedline
    #skinned meshes
    0x80000000: mesh_skinned
    0x80000001: billboard_skinned
    0x80000002: particle_skinned
    0x80000005: skeleton_skinned
    0x80000009: cloth_skinned
    0x8000000A: phys_coll_skinned
    0x8000000B: bone_link
    0x8000000D: sound_sphere_skinned
    0x8000000E: speedline_skinned
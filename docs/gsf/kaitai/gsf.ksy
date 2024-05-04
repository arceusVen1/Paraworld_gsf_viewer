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
      - id: content_table
        type: content_table
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
      - id: num_models
        type: u4
      - id: num_anims
        type: u4
      - id: zero2
        contents: [0x00, 0x00, 0x00, 0x00]
      - id: model_info_offset
        type: u4
      - id: num_model_info
        type: u4
      - id: anim_info_offset
        type: u4
      - id: num_anim_info
        type: u4
      - id: materials_header
        type: materials_header
    instances:
      model_info:
        pos: model_info_offset + _io.pos + 16
        type: model_info(_io.pos)
        size: 84
        repeat: expr
        repeat-expr: num_model_info
        if: model_info_offset != 0x80000000
      anim_info:
        pos: anim_info_offset + _io.pos + 24
        type: anim_info(_io.pos)
        size: 28
        repeat: expr
        repeat-expr: num_anim_info
        if: anim_info_offset != 0x80000000
  content_table:
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
      - id: hit_reaction_fa_anim_index
        type: u1
      - id: hit_reaction_la_anim_index
        type: u1
      - id: hit_reaction_ra_anim_index
        type: u1
      - id: hit_reaction_ba_anim_index
        type: u1
      - id: hit_reaction_fb_anim_index
        type: u1
      - id: hit_reaction_lb_anim_index
        type: u1
      - id: hit_reaction_rb_anim_index
        type: u1
      - id: hit_reaction_bb_anim_index
        type: u1
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
      - id: model_anim_index
        type: u2
      - id: dusttrail_name_num_chars
        type: u4
      - id: dusttrail_name
        type: str
        size: dusttrail_name_num_chars
        encoding: ASCII
      - id: start_frame
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
  model_info:
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
      - id: bool_read_data_maybe
        contents: [0x01, 0x00, 0x00, 0x00]
      - id: first_particle_chunk_index
        type: u2
      - id: num_particle_chunks
        type: u2
      - id: first_link_chunk_index
        type: u2
      - id: num_link_chunks
        type: u2
        #misc chunks - selection_volume,particle and maybe more
      - id: bool_misc_mesh_chunks_exists
        type: u1
      - id: num_skeleton_chunks
        type: u1
      - id: num_physcoll_chunks
        type: u1
      - id: num_cloth_chunks
        type: u1
      - id: first_selection_volume_chunk_index
        type: u1
      - id: num_selection_volume_chunks
        type: u1
      - id: num_speedline_chunks
        type: u1
      - id: zero
        contents: [0x00]
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
            mesh_chunk_type::particle: particle_chunk
            mesh_chunk_type::skeleton: skeleton_chunk(_io.pos)
            mesh_chunk_type::unk_type: unk_type_chunk
            mesh_chunk_type::cloth: cloth_chunk(_io.pos)
            mesh_chunk_type::phys_coll: phys_coll_chunk
            mesh_chunk_type::pos_link: pos_link_chunk
            mesh_chunk_type::selection_volume: selection_volume_chunk
            mesh_chunk_type::speedline: speedline_chunk
            #Skinned chunks:
            mesh_chunk_type::mesh_skinned: mesh_skinned_chunk(_io.pos)
            mesh_chunk_type::mesh_skinned_simple: mesh_skinned_simple_chunk(_io.pos)
            mesh_chunk_type::billboard_skinned: billboard_skinned_chunk(_io.pos)
            mesh_chunk_type::particle_skinned: particle_skinned_chunk
            mesh_chunk_type::cloth_skinned: cloth_skinned_chunk(_io.pos)
            mesh_chunk_type::cloth_skinned_simple: cloth_skinned_simple_chunk(_io.pos)
            mesh_chunk_type::phys_coll_skinned: phys_coll_skinned_chunk
            mesh_chunk_type::bone_link: bone_link_chunk
            mesh_chunk_type::selection_volume_skinned: selection_volume_skinned_chunk
            mesh_chunk_type::speedline_skinned: speedline_skinned_chunk	
  unk_type_chunk:
    seq:
      - id: attributes
        type: u4
      - id: guid
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
      - id: unk_float6
        type: f4
      - id: unk_float7
        type: f4
  selection_volume_chunk:
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: num_unk
        type: u4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: scale_x
        type: f4
      - id: scale_y
        type: f4
      - id: scale_z
        type: f4
  selection_volume_skinned_chunk:
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: num_unk
        type: u4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: scale_x
        type: f4
      - id: scale_y
        type: f4
      - id: scale_z
        type: f4
      - id: skeleton_index
        type: u4
      - id: bone_ids
        size: 4
      - id: bone_weights
        size: 4
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
      - id: skeleton_index
        type: u4
      - id: bone_ids
        size: 4
      - id: bone_weights
        size: 4
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
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: scale_x
        type: f4
      - id: scale_y
        type: f4
      - id: scale_z
        type: f4
      - id: guat_x
        type: f4
      - id: guat_y
        type: f4
      - id: guat_z
        type: f4
      - id: guat_w
        type: f4
      - id: num_child_bones1
        type: u4
      - id: child_bone_offset
        type: u4
      - id: num_child_bones2
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
        type: bone(_io.pos)
        repeat: expr
        repeat-expr: num_child_bones1
        if: child_bone_offset != 0x80000000
    instances:
      bind_pose:
        io: _root._io
        pos: pos + bind_pose_offset + 72
        type: bind_pose
        repeat: expr
        repeat-expr: num_all_bones
        if: bind_pose_offset != 0x80000000
  bone:
    params:
      - id: pos
        type: s4
    seq:
      - id: guid
        type: u4
      - id: flags
        type: u4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: scale_x
        type: f4
      - id: scale_y
        type: f4
      - id: scale_z
        type: f4
      - id: guat_x
        type: f4
      - id: guat_y
        type: f4
      - id: guat_z
        type: f4
      - id: guat_w
        type: f4
      - id: num_child_bones1
        type: u4
      - id: child_bone_offset
        type: u4
      - id: num_child_bones2
        type: u4
    instances:
      bone:
        io: _root._io
        pos: pos + child_bone_offset + 52
        type: bone(_io.pos)
        repeat: expr
        repeat-expr: num_child_bones1
        if: child_bone_offset != 0x80000000
  bind_pose:
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
        size: vertex_type
        repeat: expr
        repeat-expr: num_vertices
        if: vertices_offset != 0x80000000
      triangles_data:
        io: _root._io
        pos: pos + triangles_offset + 36
        size: num_triangles * 6
        if: triangles_offset != 0x80000000
      light_data:
        io: _root._io
        pos: pos + light_data_offset + 48
        size: 6
        repeat: expr
        repeat-expr: num_light_data
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
  mesh_skinned_simple_chunk:
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
      - id: unk
        type: u4
      - id: skeleton_index
        type: u4
      - id: bone_ids
        size: 4
      - id: bone_weights
        size: 4
      - id: global_bbox_offset
        type: u4
      - id: mesh_chunk_unk1
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
      - id: submesh_info
        type: submesh_info(_io.pos)
        repeat: expr
        repeat-expr: num_submesh_info
    instances:
      submesh_materials:
        io: _root._io
        pos: pos + submesh_materials_offset + 132
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
      - id: cloth_mesh_index_in_chunks_table
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
        size: vertex_type
        repeat: expr
        repeat-expr: num_vertices
        if: vertices_offset != 0x80000000
      triangles_data:
        io: _root._io
        pos: pos + triangles_offset + 40
        size: num_triangles * 6
        if: triangles_offset != 0x80000000
      light_data:
        io: _root._io
        pos: pos + light_data_offset + 48
        size: 6
        repeat: expr
        repeat-expr: num_light_data
        if: light_data_offset != 0x80000000
  cloth_skinned_chunk:
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
      - id: cloth_mesh_index_in_chunks_table
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
        pos: pos + submesh_materials_offset + 152
        type: u2
        repeat: expr
        repeat-expr: num_submesh_materials
        if: submesh_materials_offset != 0x80000000
  cloth_skinned_simple_chunk:
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
      - id: bone_ids
        size: 4
      - id: bone_weights
        size: 4
      - id: global_bbox_offset
        type: u4
      - id: cloth_mesh_index_in_chunks_table
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
        pos: pos + submesh_materials_offset + 160
        type: u2
        repeat: expr
        repeat-expr: num_submesh_materials
        if: submesh_materials_offset != 0x80000000
  particle_chunk:
    seq:
      - id: attribs
        type: u4
      - id: guid
        type: u4
      - id: unk
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
      - id: unk_float6
        type: f4
      - id: unk_float7
        type: f4
      - id: unk_float8
        type: f4
      - id: spread
        type: f4
      - id: max_parts
        type: u4
      - id: unk_float10
        type: f4
      - id: particle_name_offset
        type: u4
      - id: num_unk5
        type: u4
      - id: num_unk6
        type: u4
      - id: num_unk7
        type: u4
      - id: num_unk8
        type: u4
      - id: particle_name
        type: particle_name
        if: particle_name_offset != 0x80000000
      - id: unk1
        size: 9
      - id: size
        type: f4
      - id: life_time
        type: f4
      - id: rotate
        type: f4
      - id: gravitation
        type: f4
      - id: size_var
        type: f4
      - id: drag
        type: f4
      - id: unk3
        size: 4
      - id: col_alp_fadein
        type: f4
      - id: col_alp_fadeout
        type: f4
      - id: tile_anim_speed
        type: f4
      - id: lifetime_var
        type: f4
      - id: size_increase
        type: f4
      - id: color_var_r
        type: u4
      - id: color_var_g
        type: u4
      - id: color_var_b
        type: u4
      - id: emit_timer
        type: f4
      - id: speed_var
        type: f4
        if: particle_name_offset != 0x80000000
      - id: emit_timer_var
        type: f4
        if: particle_name_offset != 0x80000000
      - id: color_r
        type: u4
        if: particle_name_offset != 0x80000000
      - id: color_g
        type: u4
        if: particle_name_offset != 0x80000000
      - id: color_b
        type: u4
        if: particle_name_offset != 0x80000000
      - id: emit_rot_inc
        type: f4
        if: particle_name_offset != 0x80000000
      - id: src_rot_speed
        type: f4
        if: particle_name_offset != 0x80000000
      - id: center_suck
        type: f4
        if: particle_name_offset != 0x80000000
      - id: suck_vel
        type: f4
        if: particle_name_offset != 0x80000000
      - id: rotation_var
        type: f4
        if: particle_name_offset != 0x80000000
      - id: alpha
        type: u4
        if: particle_name_offset != 0x80000000
      - id: emit_per_meter
        type: f4
        if: particle_name_offset != 0x80000000
      - id: size_inc_exp
        type: f4
        if: particle_name_offset != 0x80000000
  particle_name:
    seq:
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
  particle_skinned_chunk:
    seq:
      - id: unk
        type: u4
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
        size: vertex_type
        repeat: expr
        repeat-expr: num_vertices
        if: vertices_offset != 0x80000000
  billboard_skinned_chunk:
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
      - id: unk
        type: u4
      - id: unk1
        type: u4
      - id: unk2
        type: u4
      - id: unk3
        type: u4
      - id: unk4
        type: u4
      - id: unk5
        type: u4
      - id: unk6
        type: u4
      - id: unk7
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
      - id: num_vertices
        type: u4
      - id: vertices_offset
        type: u4
      - id: vertex_type
        type: u4
    instances:
      vertices_data:
        io: _root._io
        pos: pos + vertices_offset + 132
        size: vertex_type
        repeat: expr
        repeat-expr: num_vertices
        if: vertices_offset != 0x80000000
  phys_coll_chunk:
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: unk
        type: u4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: sphere_size
        type: f4
      - id: unk_float
        type: f4
      - id: unk1
        type: u4
      - id: unk2
        type: u4
      - id: phys_coll_chunk_index
        type: u4
  phys_coll_skinned_chunk:
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: unk
        type: u4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: sphere_size
        type: f4
      - id: unk_float
        type: f4
      - id: unk1
        type: u4
      - id: unk2
        type: u4
      - id: phys_coll_chunk_index
        type: u4
      - id: skeleton_index
        type: u4
      - id: bone_ids
        size: 4
      - id: bone_weights
        size: 4
  speedline_chunk:
    seq:
      - id: attributes
        type: u4
      - id: guid
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
      - id: unk_float6
        type: f4
      - id: unk_float7
        type: f4
      - id: unk_float8
        type: f4
      - id: unk
        size: 10
  speedline_skinned_chunk:
    seq:
      - id: attributes
        type: u4
      - id: guid
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
      - id: unk_float6
        type: f4
      - id: unk_float7
        type: f4
      - id: unk_float8
        type: f4
      - id: unk
        size: 10
      - id: skeleton_index
        type: u4
      - id: bone_ids
        size: 4
      - id: bone_weights
        size: 4
  fallback_table:
    seq:
      - id: header2_neg_offset
        type: s4
      - id: model_info_neg_offset
        type: s4
      - id: fallback_num_unk
        contents: [0x0C, 0x00, 0x00, 0x00]
      - id: num_used_materials
        type: u4
      - id: fallback_num_unk2
        contents: [0x01, 0x00, 0x00, 0x00]
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
      - id: model_info_neg_offset
        type: s4
      - id: anim_chunks_table_offset
        type: u4
      - id: num_offsets
        type: u4
    instances:
      anim_chunks_table:
        #wip pos is working but ugly
        io: _root._io
        pos: _parent.anim_chunks_table_header_offset - 88 + _parent.pos + pos + anim_chunks_table_offset + i*12
        type: anim_chunks_table(_io.pos, _index)
        repeat: expr
        repeat-expr: num_offsets
        if: anim_chunks_table_offset != 0x80000000
  anim_chunks_table:
    params:
      - id: pos
        type: s4
      - id: i
        type: s4
    seq:
      - id: anim_chunk_neg_offset
        type: s4
      - id: num_anim_frames
        type: u4
    instances:
      anim_chunk:
        io: _root._io
        pos: pos + anim_chunk_neg_offset
        type: anim_chunk
        if: anim_chunk_neg_offset != 0x80000000
  anim_chunk:
    seq:
      - id: chunk_type_enum
        type: u4
        enum: anim_chunk_type
      - id: chunk_info
        type:
          switch-on: chunk_type_enum
          cases:
            anim_chunk_type::anim_type_1: anim_chunk_type_1(_io.pos)
            anim_chunk_type::anim_type_2: anim_chunk_type_2(_io.pos)
  anim_chunk_type_1:
    params:
      - id: pos
        type: s4
    seq:
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
  anim_chunk_type_2:
    params:
      - id: pos
        type: s4
    seq:
      - id: attributes
        type: u4
      - id: guid
        type: u4
      - id: unk
        type: u4
      - id: loop_start_frame
        type: u2
      - id: loop_end_frame
        type: u2
      - id: unk_float
        type: f4
      - id: unk1
        type: u4
      - id: anim_global_pos_offset
        type: u4
      - id: anim_splitter_offset
        type: u4
      - id: num_anim_splitter
        type: u4
      - id: num_anim_frames
        type: u4
      - id: walk_anim_unk_float
        type: f4
      - id: walk_anim_unk_float1
        type: f4
      - id: walk_anim_unk_float2
        type: f4
    instances:
      anim_global_pos:
        io: _root._io
        pos: pos + anim_global_pos_offset + 24
        type: anim_global_pos
        repeat: expr
        repeat-expr: num_anim_frames
        if: anim_global_pos_offset != 0x80000000
      anim_splitter:
        io: _root._io
        pos: pos + anim_splitter_offset + 28
        type: anim_splitter(_io.pos, num_anim_frames)
        repeat: expr
        repeat-expr: num_anim_splitter
        if: anim_splitter_offset != 0x80000000
  anim_splitter:
    params:
      - id: pos
        type: s4
      - id: num_anim_frames
        type: s4
    seq:
      - id: affected_bones_maybe
        type: u4
      - id: next_anim_data_offset
        type: u4
      - id: next_anim_splitter_offset
        type: u4
      - id: num_next_anim_splitter
        type: u4
    instances:
      anim_frames:
        io: _root._io
        pos: pos + next_anim_data_offset + 4
        type: anim_frame
        repeat: expr
        repeat-expr: num_anim_frames
        if: next_anim_data_offset != 0x80000000
      anim_splitter_next:
        io: _root._io
        pos: pos + next_anim_splitter_offset + 8
        type: anim_splitter(_io.pos, num_anim_frames)
        repeat: expr
        repeat-expr: num_next_anim_splitter
        if: next_anim_splitter_offset != 0x80000000
  anim_global_pos:
    seq:
      - id: guat_x
        type: f4
      - id: guat_y
        type: f4
      - id: guat_z
        type: f4
      - id: guat_w
        type: f4
      - id: pos_x
        type: f4
      - id: pos_y
        type: f4
      - id: pos_z
        type: f4
      - id: scale_x
        type: f4
      - id: scale_y
        type: f4
      - id: scale_z
        type: f4
  anim_frame:
    seq:
      - id: guat_x
        type: f4
      - id: guat_y
        type: f4
      - id: guat_z
        type: f4
      - id: guat_w
        type: f4
  anim_info:
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
      - id: animated_texture_offset
        type: u4
      - id: num_animated_texture_offsets
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
        type: anim_chunk_neg_offset
        repeat: expr
        repeat-expr: num_anim_start_pointer_offsets
        if: anim_start_pointer_offset != 0x80000000
      animated_texture:
        io: _root._io
        pos: pos + animated_texture_offset - 12
        type: animated_texture(_io.pos)
        repeat: expr
        repeat-expr: num_animated_texture_offsets
        if: animated_texture_offset != 0x80000000
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
  anim_chunk_neg_offset:
    seq:
      - id: anim_chunk_neg_offset
        type: s4
  animated_texture:
    params:
      - id: pos
        type: s4
    seq:
      - id: materials_header_neg_offset
        type: s4
      - id: header2_neg_offset
        type: s4
      - id: anim_texture_table_offset
        type: u4
      - id: num_textures
        type: u4
      - id: unk2
        type: u4
    instances:
      anim_texture_table:
        io: _root._io
        #pos is wrong
        pos: pos + anim_texture_table_offset + 8
        type: anim_texture
        repeat: expr
        repeat-expr: num_textures
        if: anim_texture_table_offset != 0x80000000
  anim_texture:
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
    #aje_scarecrow
    0x00000008: unk_type
    0x00000009: cloth
    0x0000000A: phys_coll
    0x0000000B: pos_link
    0x0000000D: selection_volume
    0x0000000E: speedline
    #skinned meshes
    0x80000000: mesh_skinned
    0x20000000: mesh_skinned_simple
    0x80000001: billboard_skinned
    0x80000002: particle_skinned
    0x20000009: cloth_skinned_simple
    0x80000009: cloth_skinned
    0x8000000A: phys_coll_skinned
    0x8000000B: bone_link
    0x8000000D: selection_volume_skinned
    0x8000000E: speedline_skinned
  anim_chunk_type:
    0x40000003: anim_type_1
    0x40000005: anim_type_2
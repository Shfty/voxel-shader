class_name VoxelModel
extends Resource
tool

export(Array, Array, Array, Color) var cells := [] setget set_cells
export(ArrayMesh) var mesh: ArrayMesh = null setget set_mesh

func set_cells(new_cells: Array) -> void:
	if cells != new_cells:
		cells = new_cells
		rebuild()

func set_mesh(new_mesh: ArrayMesh) -> void:
	if not new_mesh:
		new_mesh = ArrayMesh.new()

	if mesh != new_mesh:
		mesh = new_mesh

func rebuild() -> void:
	while mesh.get_surface_count() > 0:
		mesh.surface_remove(0)

	var size = Vector3.ZERO
	size.x = cells.size()
	size.y = cells[0].size()
	size.z = cells[0][0].size()

	var arrays := []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = PoolVector3Array()
	arrays[ArrayMesh.ARRAY_NORMAL] = PoolVector3Array()
	arrays[ArrayMesh.ARRAY_COLOR] = PoolColorArray()
	arrays[ArrayMesh.ARRAY_INDEX] = PoolIntArray()

	for x in range(0, size.x):
		for y in range(0, size.y):
			for z in range(0, size.z):
				var pos = Vector3(x, y, z)
				var half = Vector3.ONE * 0.5

				var color = cells[x][y][z]
				if color.a > 0.0:

					var idx_head = arrays[ArrayMesh.ARRAY_VERTEX].size()

					arrays[ArrayMesh.ARRAY_VERTEX] += PoolVector3Array([
						pos - half + Vector3(0, 0, 0),
						pos - half + Vector3(0, 1, 0),
						pos - half + Vector3(0, 1, 1),
						pos - half + Vector3(0, 0, 1),

						pos - half + Vector3(0, 0, 0),
						pos - half + Vector3(0, 0, 1),
						pos - half + Vector3(1, 0, 1),
						pos - half + Vector3(1, 0, 0),

						pos - half + Vector3(0, 0, 0),
						pos - half + Vector3(1, 0, 0),
						pos - half + Vector3(1, 1, 0),
						pos - half + Vector3(0, 1, 0),

						pos + half + Vector3(0, 0, 0),
						pos + half + Vector3(0, 0, -1),
						pos + half + Vector3(0, -1, -1),
						pos + half + Vector3(0, -1, 0),

						pos + half + Vector3(0, 0, 0),
						pos + half + Vector3(-1, 0, 0),
						pos + half + Vector3(-1, 0, -1),
						pos + half + Vector3(0, 0, -1),

						pos + half + Vector3(0, 0, 0),
						pos + half + Vector3(0, -1, 0),
						pos + half + Vector3(-1, -1, 0),
						pos + half + Vector3(-1, 0, 0),
					])

					arrays[ArrayMesh.ARRAY_NORMAL] += PoolVector3Array([
						Vector3(1, 0, 0),
						Vector3(1, 0, 0),
						Vector3(1, 0, 0),
						Vector3(1, 0, 0),

						Vector3(0, -1, 0),
						Vector3(0, -1, 0),
						Vector3(0, -1, 0),
						Vector3(0, -1, 0),

						Vector3(0, 0, 1),
						Vector3(0, 0, 1),
						Vector3(0, 0, 1),
						Vector3(0, 0, 1),

						Vector3(-1, 0, 0),
						Vector3(-1, 0, 0),
						Vector3(-1, 0, 0),
						Vector3(-1, 0, 0),

						Vector3(0, 1, 0),
						Vector3(0, 1, 0),
						Vector3(0, 1, 0),
						Vector3(0, 1, 0),

						Vector3(0, 0, -1),
						Vector3(0, 0, -1),
						Vector3(0, 0, -1),
						Vector3(0, 0, -1),
					])

					arrays[ArrayMesh.ARRAY_COLOR] += PoolColorArray([
						color,
						color,
						color,
						color,

						color,
						color,
						color,
						color,

						color,
						color,
						color,
						color,

						color,
						color,
						color,
						color,

						color,
						color,
						color,
						color,

						color,
						color,
						color,
						color,
					])

					arrays[ArrayMesh.ARRAY_INDEX] += PoolIntArray([
						idx_head + 0, idx_head + 1, idx_head + 2, idx_head + 2, idx_head + 3, idx_head + 0,
						idx_head + 4, idx_head + 5, idx_head + 6, idx_head + 6, idx_head + 7, idx_head + 4,
						idx_head + 8, idx_head + 9, idx_head + 10, idx_head + 10, idx_head + 11, idx_head + 8,

						idx_head + 12, idx_head + 13, idx_head + 14, idx_head + 14, idx_head + 15, idx_head + 12,
						idx_head + 16, idx_head + 17, idx_head + 18, idx_head + 18, idx_head + 19, idx_head + 16,
						idx_head + 20, idx_head + 21, idx_head + 22, idx_head + 22, idx_head + 23, idx_head + 20,
					])

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

func _init() -> void:
	if get_name().empty():
		set_name("VoxelModel")

class_name GridMesh
extends ArrayMesh
tool

export(int) var tesselation = 1 setget set_tesselation
export(float) var size := 1.0 setget set_size
export(bool) var inset := true

func set_tesselation(new_tesselation: int) -> void:
	if tesselation != new_tesselation:
		tesselation = new_tesselation
		rebuild()

func set_size(new_size: float) -> void:
	if size != new_size:
		size = new_size
		rebuild()

func rebuild() -> void:
	while get_surface_count() > 0:
		surface_remove(0)

	var hw = tesselation * 0.5

	var vertices := PoolVector3Array()
	var uvs := PoolVector2Array()

	var cells_side = tesselation
	if inset:
		cells_side *= 3

	for y in range(0, cells_side + 1):
		for x in range(0, cells_side + 1):
			var uv = Vector2(x, y) / cells_side
			var local = Vector3(x, y, 0.0) / cells_side
			if inset:
				var mx = x % 3
				var my = y % 3

				if mx == 1:
					local.x -= 1.0 / cells_side
				elif mx == 2:
					local.x += 1.0 / cells_side

				if my == 1:
					local.y -= 1.0 / cells_side
				elif my == 2:
					local.y += 1.0 / cells_side

				if mx > 0 and my > 0:
					local.z = 1.0 / 64.0
			var centered = local - Vector3.ONE * 0.5
			vertices.append(centered * size)
			uvs.append(uv)

	var indices := PoolIntArray()
	for i in range(0, (cells_side + 1) * cells_side):
		if i % (cells_side + 1) == cells_side:
			continue

		indices.append(i)
		indices.append(i + (cells_side + 1))
		indices.append(i + 1)

		indices.append(i + (cells_side + 1))
		indices.append(i + cells_side + 2)
		indices.append(i + 1)

	var arrays := []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_TEX_UV] = uvs
	arrays[ArrayMesh.ARRAY_INDEX] = indices

	# Create the Mesh.
	add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

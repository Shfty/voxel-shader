class_name VoxelModelBuilder
extends ImmediateGeometry
tool

export(bool) var rebuild := false setget set_rebuild
export(Vector3) var size := Vector3.ONE * 3 setget set_size

export(Resource) var voxel_model: Resource = null setget set_voxel_model

func set_size(new_size: Vector3) -> void:
	new_size = new_size.round()

	if size != new_size:
		size = new_size
		size_changed()

func set_rebuild(new_rebuild: bool) -> void:
	if new_rebuild:
		rebuild()

func set_voxel_model(new_voxel_model: Resource) -> void:
	if not new_voxel_model is VoxelModel:
		new_voxel_model = VoxelModel.new()

	if voxel_model != new_voxel_model:
		voxel_model = new_voxel_model
		rebuild()

func _enter_tree() -> void:
	size_changed()

func size_changed() -> void:
	clear()

	var ofs = -Vector3.ONE * 0.5
	for x in range(0, size.x + 1):
		for y in range(0, size.y + 1):
			for z in range(0, size.z + 1):
				begin(Mesh.PRIMITIVE_LINES)
				add_vertex(ofs + Vector3(0, y, z))
				add_vertex(ofs + Vector3(size.x, y, z))
				end()

				begin(Mesh.PRIMITIVE_LINES)
				add_vertex(ofs + Vector3(x, 0, z))
				add_vertex(ofs + Vector3(x, size.y, z))
				end()

				begin(Mesh.PRIMITIVE_LINES)
				add_vertex(ofs + Vector3(x, y, 0))
				add_vertex(ofs + Vector3(x, y, size.z))
				end()

	if is_inside_tree():
		rebuild()

func rebuild() -> void:
	var cells := []

	for x in range(0, size.x):
		while cells.size() <= x:
			cells.append([])
		for y in range(0, size.y):
			while cells[x].size() <= y:
				cells[x].append([])
			for z in range(0, size.z):
				cells[x][y].append(Color.transparent)

	for child in get_children():
		if child is Voxel:
			var p = child.transform.origin
			if AABB(Vector3.ZERO, size).has_point(p):
				cells[p.x][p.y][p.z] = child.color

	voxel_model.set_cells(cells)

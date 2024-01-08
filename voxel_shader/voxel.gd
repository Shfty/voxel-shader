class_name Voxel
extends MeshInstance
tool

export(Color) var color := Color.white setget set_color

func set_color(new_color: Color) -> void:
	if color != new_color:
		color = new_color
		update_color()

func _init() -> void:
	mesh = CubeMesh.new()
	mesh.size = Vector3.ONE
	mesh.material = SpatialMaterial.new()
	update_color()

func update_color() -> void:
	mesh.material.albedo_color = color

func _process(delta: float) -> void:
	transform.origin = transform.origin.round()

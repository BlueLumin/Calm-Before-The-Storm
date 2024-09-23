@tool
extends Marker2D
class_name ResourseSpawnPoint

@export var resource_type: String:
	set(value):
		if Engine.is_editor_hint():
			self.name = value
		
		resource_type = value


var picked:bool = false


func _ready() -> void:
	if not Engine.is_editor_hint():
		for child in get_children():
			child.queue_free()


func spawn_resource(resource: PackedScene):
	var resource_instance = resource.instantiate()
	resource_instance.global_position = global_position
	var object_layer = get_tree().get_first_node_in_group("object_layer")
	object_layer.add_child(resource_instance)

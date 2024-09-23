extends Node2D

@export var elevator: StaticBody2D

@onready var down_position: Marker2D = $DownPosition
@onready var up_position: Marker2D = $UpPosition


func move_up_shaft():
	elevator.move_towards_pos(down_position.global_position, up_position.global_position)
	await elevator.position_reached
	change_scene("world")


func move_down_shaft():
	elevator.move_towards_pos(up_position.global_position, down_position.global_position)
	await elevator.position_reached
	change_scene("base")


func change_scene(scene: String):
	var scene_manager = get_tree().get_first_node_in_group("scene_manager") as SceneManager
	if scene_manager:
		scene_manager.request_scene_change(scene)
		return
	
	push_warning("No scene manager found in ", self)

extends Node2D

@onready var elevator: StaticBody2D = $Elevator
@onready var exit_area: Area2D = $ExitArea

@export var player: CharacterBody2D

var scene_manager: SceneManager
var can_exit: bool = false


func _ready() -> void:
	GameEvents.start_scene.connect(on_scene_started)
	
	exit_area.set_monitoring(false)
	exit_area.body_entered.connect(on_exit_area_entered)
	exit_area.body_exited.connect(on_exit_area_exited)
	
	scene_manager = get_tree().get_first_node_in_group("scene_manager")
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_exit:
		if scene_manager == null:
			scene_manager = get_tree().get_first_node_in_group("scene_manager")
			if scene_manager == null:
				return
		player.active = false
		scene_manager.request_scene_change("elevator")
		scene_manager.elevator_direction = "up"


func move_player_off_elevator():
	elevator.left_wall_collision_shape.set_deferred("disabled", true)
	elevator.right_wall_collision_shape.set_deferred("disabled", true)
	
	player.active = true
	exit_area.set_monitoring(true)
	
	if not GlobalVariables.base_tut_done:
		GameEvents.emit_create_tutorial("This game is unfinished. \n
		Unfortunately, due to unforeseen circumstances we are not able to complete this game for the Brackeys Game Jam 2024.2.
		This is more a proof of concept to show off the work we did manage to do. There will be lots of bugs and some debugging tools are still in place.
		\n
		The goal is to collect Fuel Points (FP) above ground in between the dangerous storms that sweep across the land.\n
		To begin, walk into the elevator and press - E -")
		
		GlobalVariables.base_tut_done = true

func on_scene_started():
	elevator.move_towards_pos(
		elevator.global_position, 
		Vector2(elevator.global_position.x, 60)
		)
	
	if player == null:
		push_warning(self, " doesn't have a player assigned.")
		return
	
	await elevator.position_reached
	move_player_off_elevator()


func on_exit_area_entered(body: Node2D):
	can_exit = true


func on_exit_area_exited(body: Node2D):
	can_exit = false

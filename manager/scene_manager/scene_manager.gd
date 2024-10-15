# Root script that handles scene change requests, fading in and out, and scene requirments.
extends Node2D
class_name SceneManager

@onready var current_scene: Node2D = $CurrentScene
@onready var fade: Fade = $Fade

var elevator_direction = null

var scene_list: Dictionary = {
	"elevator": preload("res://scene/elevator/elevator_shaft.tscn"),
	"world": preload("res://scene/world/world.tscn"),
	"base": preload("res://scene/base/base.tscn"),
}


func _ready() -> void:
	GameEvents.fp_objective_completed.connect(on_fp_objective_completed)
	GameEvents.pause_game.connect(on_pause_game)
	
	#DEBUG
	GameEvents.storm_timer_finished.connect(on_storm_timer_up)
	#DEBUG
	
	current_scene.scene_loaded.connect(on_scene_loaded)
	
	fade.fade_in()
	await  fade.fade_in_completed
	
	GameEvents.emit_start_scene()


func request_scene_change(new_scene: String):
	var player = get_tree().get_first_node_in_group("player") as Player
	if player:
		player.is_active = false
	
	fade.fade_out()
	await fade.fade_out_completed
	on_change_scene(new_scene)


func check_scene_requirements(scene: String):
	match scene:
		"world":
			activate_player()
			
			if not GlobalVariables.world_tut_done:
				GameEvents.emit_create_tutorial("
				This is the surface world. The timer at the top is how long you have before the next storm happens.\n
				The number at the top left is how many FP (Fuel Points) you have and how many you need.\n
				The objectives at the top right are optional, and in the final game would've given you bonus points.\n
				Press - E - when next to a resource to collect it.\n
				Press - M - to pause the game and view the map. This will show you where different resources are located. These change position each day.\n
				Finally, once you have reached (or exceeded) your target FPs, you can return to base by pressing - E - next to the base structure.
				")
				
				GlobalVariables.world_tut_done = true
				
		"elevator":
			var elevator_scene = current_scene.get_node("ElevatorShaft")
			match elevator_direction:
				"down":
					elevator_scene.move_down_shaft()
				"up":
					elevator_scene.move_up_shaft()
				null:
					elevator_scene.move_up_shaft()
			elevator_direction = null


func activate_player():
	var player = get_tree().get_first_node_in_group("player") as Player
	if player:
		player.is_active = true
		var game_camera = get_tree().get_first_node_in_group("game_camera") as GameCamera
		if game_camera:
			game_camera.target = player
		else:
			push_warning("no game camerma found in ", self)
	else:
		push_warning("no player found in ", self)


func on_change_scene(new_scene: String):
	for scene in current_scene.get_children():
		scene.queue_free()
		await scene.tree_exited
	
	var new_scene_instance = scene_list[new_scene].instantiate()
	current_scene.add_child(new_scene_instance)
	
	current_scene.check_if_scene_needs_to_load(new_scene)


func on_scene_loaded(new_scene: String):
	fade.fade_in()
	
	await fade.fade_in_completed
	
	check_scene_requirements(new_scene)
	GameEvents.emit_start_scene()


func on_fp_objective_completed():
	request_scene_change("elevator")
	elevator_direction = "down"

# DEBUG
func on_storm_timer_up():
	request_scene_change("world")
# DEBUG

func on_pause_game(paused: bool):
	get_tree().paused = paused

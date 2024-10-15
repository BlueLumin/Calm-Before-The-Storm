# Handles the current scene and loading the "world".
extends Node2D

signal scene_loaded

var current_scene: String


func check_if_scene_needs_to_load(scene: String):
	current_scene = scene
	if scene == "world":
		GlobalVariables.current_fp = 0 # Reset Fuel Points at start of world level.
		
		var objective_manager = get_tree().get_first_node_in_group("objective_manager") as ObjectiveManager
		
		if objective_manager != null:
			objective_manager.pick_objectives()
		else:
			push_warning(self, " couldn't locate the objective_manager.")
		
		var resource_spawner = get_tree().get_first_node_in_group("resource_spawn_manager") as ResourceSpawner
		
		if resource_spawner == null:
			push_warning(self, " couldn't locate the resource_spawner.")
			on_level_created()
			return
		
		if resource_spawner.level_created.is_connected(on_level_created):
			resource_spawner.level_created.disconnect(on_level_created)
		
		resource_spawner.level_created.connect(on_level_created)
		resource_spawner.create_level()
		
	else:
		on_level_created()


func on_level_created():
	scene_loaded.emit(current_scene)

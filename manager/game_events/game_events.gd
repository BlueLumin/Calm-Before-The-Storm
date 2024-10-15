# Stores signals that can be emitted by any scene and listened to by others.
extends Node

signal objectives_picked(picked: Array)
signal collectable_picked_up(collectable: CollectableResource)
signal update_objective_progress(objective: ObjectiveResource)
signal all_objectives_completed
signal fp_objective_completed
signal create_notification(text: String)
signal return_to_base
signal start_scene
signal storm_timer_finished
signal resouce_spawned(resource_name: String, pos: Vector2)
signal pause_game(paused: bool)
signal create_tutorial(tutorial: String)


func emit_objectives_picked(picked: Array):
	objectives_picked.emit(picked)


func emit_collectable_picked_up(collectable: CollectableResource):
	collectable_picked_up.emit(collectable)


func emit_update_objective_progress(objective: ObjectiveResource):
	update_objective_progress.emit(objective)


func emit_all_objectives_completed():
	all_objectives_completed.emit()


func emit_fp_objective_completed():
	fp_objective_completed.emit()


func emit_create_notification(text: String):
	create_notification.emit(text)


func emit_return_to_base():
	return_to_base.emit()


func emit_start_scene():
	start_scene.emit()


func emit_storm_timer_finished():
	storm_timer_finished.emit()


func emit_resouce_spawned(resource_name: String, pos: Vector2):
	resouce_spawned.emit(resource_name, pos)


func emit_pause_game(paused: bool):
	pause_game.emit(paused)


func emit_create_tutorial(tutorial: String):
	create_tutorial.emit(tutorial)

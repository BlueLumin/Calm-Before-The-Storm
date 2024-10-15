# Manages the objectives.
# Selects objectives from a pool at the beginning of a game.
# Updates progression through the game.
extends Node
class_name ObjectiveManager

@export var objective_pool: Array[ObjectiveResource]

var current_objectives: Array[ObjectiveResource]
var objective_count: int = 2


func _ready() -> void:
	GameEvents.collectable_picked_up.connect(on_collectable_picked_up)
	GameEvents.return_to_base.connect(on_return_to_base)


func pick_objectives():
	clear_current_objectives()
	var picked
	var filtered_pool = objective_pool.duplicate()
	
	for n in objective_count:
		if filtered_pool.size() > 0:
			picked = filtered_pool[randi_range(0, filtered_pool.size() - 1)] as ObjectiveResource
			
			picked.quantity = randi_range(picked.quantity_range.x, picked.quantity_range.y)
			
			filtered_pool.erase(picked)
			current_objectives.append(picked)
		else:
			break
	
	objectives_picked()


func clear_current_objectives():
	for objective in current_objectives:
		objective.progress = 0
	
	current_objectives.clear()


func objectives_picked():
	GameEvents.emit_objectives_picked(current_objectives)


func check_objective_progress():
	# FP Objective
	if GlobalVariables.current_fp >= GlobalVariables.fp_objective:
		GameEvents.emit_fp_objective_completed()
	else:
		GameEvents.emit_create_notification(
		"You haven't collected enough FP! You still need " +
		str(GlobalVariables.fp_objective - GlobalVariables.current_fp) +
		" more."
		)
	
	# Optional Objectives
	var num_of_objectives = current_objectives.size()
	var num_of_completed: int = 0
	
	for objective in current_objectives:
		if objective.progress >= objective.quantity:
			num_of_completed += 1
	
	GameEvents.emit_create_notification(
		str(num_of_completed) + 
		" out of " + 
		str(num_of_objectives) + 
		" extra objectives completed."
		)
	
	if num_of_completed == num_of_objectives:
		GameEvents.emit_all_objectives_completed()


func on_return_to_base():
	check_objective_progress()


func on_collectable_picked_up(collectable: CollectableResource):
	for objective in current_objectives:
		if objective.related_resouce == collectable:
			objective.progress += 1
			GameEvents.emit_update_objective_progress(objective)
	

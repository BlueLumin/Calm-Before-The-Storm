extends PanelContainer
class_name ObjectiveCard

@onready var objective_name: Label = $MarginContainer/VBoxContainer/ObjectiveName
@onready var objective_description: Label = $MarginContainer/VBoxContainer/ObjectiveDescription

var assigned_objective: ObjectiveResource


func update_objective_name(obj_name: String):
	if is_instance_valid(objective_name):
		objective_name.text = obj_name


func update_objective_description(description: String, quantity: int, progress: int):
	if is_instance_valid(objective_name):
		objective_description.text = description % [progress, quantity]


func complete_objective(description: String):
	if is_instance_valid(objective_name):
		objective_description.text = description


func create_card(objective: ObjectiveResource):
	update_objective_name(objective.display_name)
	update_objective_description(
		objective.objective_description, 
		objective.quantity, 
		objective.progress
		)


func update_progress(objective: ObjectiveResource):
	if objective.progress >= objective.quantity:
		complete_objective(objective.completed_description)
		return
	
	update_objective_description(
		objective.objective_description, 
		objective.quantity, 
		objective.progress
		)

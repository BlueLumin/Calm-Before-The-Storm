# A component that can be added as a child of another node to extend it's functionality.
# Handles the player interacting with objects that have the InteractComponent.
extends Area2D
class_name PlayerInteractableComponent

var interact_list: Array[InteractComponent] = []
var inventory_manager: InventoryManager


func _ready() -> void:
	inventory_manager = get_tree().get_first_node_in_group("inventory_manager")
	if not inventory_manager:
		push_warning(self, " couldn't locate the inventory_manager.")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if interact_list.size() > 0:
			interact_list[0].interact.call()


func _process(delta: float) -> void:
	interact_list.sort_custom(sort_list)


func add_area_to_interact_list(area: InteractComponent):
	if interact_list.has(area):
		return
	
	interact_list.append(area)


func remove_area_from_interact_list(area: InteractComponent):
	if not interact_list.has(area):
		return
	
	interact_list.erase(area)


func sort_list(a, b) -> bool:
	var a_distance = global_position.distance_to(a.global_position)
	var b_distance = global_position.distance_to(b.global_position)
	if a_distance < b_distance:
		return true
	return false

extends Node
class_name InventoryManager

var invetory: Dictionary = {}


func _ready() -> void:
	GameEvents.collectable_picked_up.connect(on_collectable_picked_up)


func reset_inventory():
	invetory.clear()
	print("Inventory reset")


func add_collectable_to_inventory(collectable: CollectableResource):
	if invetory.has(collectable.id):
		invetory[collectable.id]["quantity"] += 1
	else:
		invetory[collectable.id] = {
			"name": collectable.collectable_name,
			"quantity": 1,
		}


func on_collectable_picked_up(collectable: CollectableResource):
	add_collectable_to_inventory(collectable)

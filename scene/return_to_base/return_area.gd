extends InteractComponent


func _ready() -> void:
	interact = self_interact
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)


func self_interact():
	GameEvents.emit_return_to_base()


func on_area_entered(other_area: Area2D):
	if not other_area is PlayerInteractableComponent:
		return
	
	var interact_area = other_area as PlayerInteractableComponent
	
	interact_area.add_area_to_interact_list(self)


func on_area_exited(other_area: Area2D):
	if not other_area is PlayerInteractableComponent:
		return
	
	var interact_area = other_area as PlayerInteractableComponent
	
	interact_area.remove_area_from_interact_list(self)

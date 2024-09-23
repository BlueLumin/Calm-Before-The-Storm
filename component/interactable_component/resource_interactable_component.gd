extends InteractComponent
class_name ResourceInteractableComponent

signal collected

@onready var interact_cooldown_timer: Timer = $InteractCooldownTimer
@onready var collison_check_timer: Timer = $CollisonCheckTimer

@export_group("Resource Settings")
@export var resource: PackedScene ## The resource's scene that gets dropped by this component.
@export_range(1, 10) var max_drop_rate: int = 1 ## How many resources this component can drop at once.
@export_range(1, 10) var min_drop_rate: int = 1 ## How few resources this component can drop at once. 

@export_group("Interact Settings")
@export var interact_number: int = 1 ## The number of times you can interact with this (-1 means infinite times).
@export var interactable: bool = true ## Determines whether or not you can interact with it.

var times_interacted: int = 0
var body = null

func _ready():
	interact = self_interact
	interact_cooldown_timer.timeout.connect(on_interact_cooldown_timer_timeout)
	collison_check_timer.timeout.connect(on_collision_check_timer_timeout)
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)


func self_interact():
	if not interactable:
		return
	
	var drop: int = randi_range(min_drop_rate, max_drop_rate)
	
	for i in drop:
		var resource_instance = resource.instantiate()
		var collectable_layer = get_tree().get_first_node_in_group("collectable_layer")
		
		if collectable_layer == null:
			push_warning(self, " cannot find collectable layer.")
			return
		
		collectable_layer.add_child(resource_instance)
		resource_instance.global_position =\
			owner.global_position\
			+ (Vector2.RIGHT * randf_range(0, 25))\
			.rotated(randf_range(0, TAU))
	
	times_interacted += 1
	check_if_still_interactable()


func check_if_still_interactable():
	if times_interacted >= interact_number:
		interactable = false
		set_deferred("monitoring", false)
		collected.emit()
	else:
		interactable = false
		interact_cooldown_timer.start()


# Checks if there is a collision in the way to the Player.
func check_for_collision() -> bool: # false = no collision & true = collision
	if body == null:
		return true
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, body.global_position)
	var result = space_state.intersect_ray(query)
	
	if not result.collider is TileMapLayer:
		return false
	
	collison_check_timer.start()
	return true


func on_area_entered(other_area: Area2D):
	if not other_area is PlayerInteractableComponent:
		return
	
	body = other_area
	
	if check_for_collision():
		return
	
	var interact_area = other_area as PlayerInteractableComponent
	
	interact_area.add_area_to_interact_list(self)


func on_area_exited(other_area: Area2D):
	if not other_area is PlayerInteractableComponent:
		return
	
	body = null
	
	var interact_area = other_area as PlayerInteractableComponent
	
	interact_area.remove_area_from_interact_list(self)


func on_interact_cooldown_timer_timeout():
	interactable = true


func on_collision_check_timer_timeout():
	if body == null:
		return
	
	if check_for_collision():
		collison_check_timer.start()
	else:
		body.add_area_to_interact_list(self)

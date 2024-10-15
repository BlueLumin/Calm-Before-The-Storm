# Root script for interactable objects.
extends Node2D

@export var sprite: Sprite2D ## The sprite that holds the 2 frames (uncollected and collected).
@export var secondary_sprite: Sprite2D ## If there is a secondary sprite.
@export var interactable_component: ResourceInteractableComponent ## The interactable Area2D node.
@export var destory_collison_on_collect: bool = false ## Should the collisions be removed for this object on collected?
@export var collision_shape: CollisionShape2D ## The collision shape to be destroyed.


func _ready() -> void:
	if sprite == null or interactable_component == null:
		push_warning(self, " doesn't have everything assigned.", sprite, " ", interactable_component)
		return
	
	interactable_component.collected.connect(on_collected)


func on_collected():
	sprite.frame += 1
	
	if secondary_sprite != null:
		secondary_sprite.frame += 1
	
	if destory_collison_on_collect:
		if collision_shape == null:
			push_warning(self, " dooesn't have a collision shape assigned.")
			return
		collision_shape.set_deferred("disabled", true)

extends CharacterBody2D
class_name Player

@onready var animation_tree: AnimationTree = $AnimationTree
var animation_state: AnimationNodeStateMachinePlayback

var speed: float = 100.0
var acceleration_smoothing: float = 8.0
var friction: float = 15.0
var direction: Vector2 = Vector2.ZERO

var is_active: bool = false


func _ready() -> void:
	animation_state = animation_tree.get("parameters/playback")
	animation_tree.set("parameters/idle/blend_position", Vector2(0, 1))


func _physics_process(delta: float) -> void:
	if is_active:
		movement(delta)
	else:
		velocity = Vector2.ZERO
		direction = Vector2.ZERO
	
	animations()
	move_and_slide()


func movement(delta: float):
	direction = get_input()
	
	var target_velocity
	
	if direction != Vector2.ZERO:
		target_velocity = direction * speed
		velocity = velocity.lerp(target_velocity, 1 - exp(-delta * acceleration_smoothing))
	else:
		target_velocity = Vector2.ZERO
		velocity = velocity.lerp(target_velocity, 1 - exp(-delta * friction))


func animations():
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/walk/blend_position", direction)
		animation_tree.set("parameters/idle/blend_position", direction)
		animation_state.travel("walk")
	else:
		animation_state.travel("idle")


func get_input():
	var input = Input.get_vector("left", "right", "up", "down")
	return input

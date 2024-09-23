extends Camera2D
class_name GameCamera

var target: Node2D


func _physics_process(delta: float) -> void:
	if target:
		move_towards_position(target.global_position, delta)


func move_towards_position(pos: Vector2, delta: float):
	global_position = global_position.lerp(pos, 1 - exp(-delta * 20))

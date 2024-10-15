# Handles the elevator's movement and starting position.
extends StaticBody2D

signal position_reached

@onready var left_wall_collision_shape: CollisionShape2D = $LeftWallCollisionShape
@onready var right_wall_collision_shape: CollisionShape2D = $RightWallCollisionShape


func move_towards_pos(starting_pos: Vector2, pos: Vector2):
	global_position = starting_pos
	var tween = create_tween()
	tween.tween_property(self, "position", pos, 3)
	await tween.finished
	position_reached.emit()

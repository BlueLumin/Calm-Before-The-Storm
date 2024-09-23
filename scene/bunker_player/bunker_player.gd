extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 50.0
const ACCELERATION = 10.0
const DEACCELERATION = 25.0

var direction: Vector2

var active: bool = false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if active:
		direction = Vector2(Input.get_axis("left", "right"), 0 )
		var target_velocity = direction * SPEED
		if direction:
			velocity = lerp(velocity, target_velocity, 1 - exp(-delta * ACCELERATION))
		else:
			velocity = lerp(velocity, Vector2.ZERO, 1 - exp(-delta * DEACCELERATION))
	else:
		velocity = Vector2.ZERO
		direction = Vector2.ZERO
	
	if direction != Vector2.ZERO:
		match  direction:
			Vector2(1, 0):
				animated_sprite.play("walk_right")
			Vector2(-1, 0):
				animated_sprite.play("walk_left")
	else:
		animated_sprite.play("idle_down")
	
	
	move_and_slide()

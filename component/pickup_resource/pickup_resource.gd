extends Node2D

@onready var pickup_area: Area2D = $PickupArea
@onready var pickup_cooldown: Timer = $PickupCooldown

@export var resource: CollectableResource
@export var sprite: Sprite2D

var waiting: bool = true

func _ready():
	if resource == null:
		push_error(self, " doesn't have a resource assigned and was deleted.")
		owner.queue_free()
	
	pickup_area.body_entered.connect(on_body_enetered)
	pickup_cooldown.start()
	hover_up()


func hover_up():
	if sprite == null:
		return
	
	var tween = create_tween()
	tween.tween_property(sprite, "offset:y", -5, 1)
	await tween.finished
	hover_down()


func hover_down():
	if sprite == null:
		return
	
	var tween = create_tween()
	tween.tween_property(sprite, "offset:y", 0, 1)
	await tween.finished
	hover_up()


func disabled_monitoring():
	pickup_area.set_monitoring(false)


func pick_up():
	if not pickup_cooldown.is_stopped():
		await pickup_cooldown.timeout
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(owner.global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	if sprite:
		tween.tween_property(sprite, "scale", Vector2.ZERO, 0.1). set_delay(0.4)
	tween.chain()
	tween.tween_callback(collect)


func tween_collect(percent: float, starting_pos: Vector2):
	var player = get_tree().get_first_node_in_group("player") as Player
	if player == null:
		return
	
	owner.global_position = starting_pos.lerp(player.global_position, percent)


func collect():
	GameEvents.emit_collectable_picked_up(resource)
	GlobalVariables.current_fp += resource.fuel_point_value
	owner.queue_free()


func on_body_enetered(body: Node2D):
	if not body is Player:
		return
	
	Callable(disabled_monitoring).call_deferred()
	waiting = false
	
	pick_up()

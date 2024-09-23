extends Node2D
class_name StormManager

@onready var storm_timer: Timer = $StormTimer


func _ready() -> void:
	GameEvents.start_scene.connect(on_start_scene)
	storm_timer.timeout.connect(on_storm_timer_timeout)


func get_storm_timer_formatted_minutes() -> int:
	if not storm_timer.is_stopped():
		var minutes: int = floor(storm_timer.time_left / 60)
		return minutes
	else:
		return 0


func get_storm_timer_formatted_seconds() -> int:
	if not storm_timer.is_stopped():
		var seconds: int = floor(
			storm_timer.time_left - 
			(get_storm_timer_formatted_minutes() * 60)
			)
		return seconds
	else:
		return 0


func on_start_scene():
	storm_timer.start()


func on_storm_timer_timeout():
	GameEvents.emit_storm_timer_finished()

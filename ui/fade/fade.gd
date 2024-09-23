extends CanvasLayer
class_name Fade

signal fade_out_completed
signal fade_in_completed

@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	visible = true


func fade_out(duration: float = 1):
	color_rect.set_color(Color(0,0,0,0))
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0,0,0,1), duration)
	await tween.finished
	fade_out_completed.emit()


func fade_in(duration: float = 1):
	color_rect.set_color(Color(0,0,0,1))
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0,0,0,0), duration)
	await tween.finished
	fade_in_completed.emit()

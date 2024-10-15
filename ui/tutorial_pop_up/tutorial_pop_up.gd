# Handles the format and display of the pop-up tutorials.
extends Control

@onready var tutorial_label: Label = $MarginContainer/MarginContainer/TutorialLabel
@onready var next_icon: TextureRect = $MarginContainer/IconMarginContainer/NextIcon
@onready var skip_animation_player: AnimationPlayer = $MarginContainer/IconMarginContainer/SkipAnimationPlayer
@onready var margin_container: MarginContainer = $MarginContainer

var skipable: bool = false


func _ready() -> void:
	GameEvents.create_tutorial.connect(on_create_tutorial)
	hide_skip_icon()
	skipable = false


func _input(event: InputEvent) -> void:
	if Input.is_anything_pressed():
		if skipable:
			tween_out()


func show_skip_icon():
	next_icon.set_deferred("modulate", Color(Color.WHITE, 1))
	skip_animation_player.play("Pulse")


func hide_skip_icon():
	skip_animation_player.stop()
	next_icon.set_deferred("modulate", Color(Color.WHITE, 0))


func tween_in():
	# 350
	skipable = false
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", 350, 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	await get_tree().create_timer(0.8).timeout
	skipable = true
	show_skip_icon()


func tween_out():
	# 500
	hide_skip_icon()
	skipable = false
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", (500 + margin_container.size.y), 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	GameEvents.emit_pause_game(false)


func on_create_tutorial(tutorial: String):
	position.y = (500 + margin_container.size.y)
	
	tutorial_label.text = tutorial
	GameEvents.emit_pause_game(true)
	tween_in()

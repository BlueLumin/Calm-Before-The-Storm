extends CanvasLayer

@onready var objectives_container: VBoxContainer = $TopHUDMarginContainer/ObjectivesContainer/VBoxContainer
@onready var notifications_list: VBoxContainer = $TopHUDMarginContainer/NotficationsContainer/NotificationsList
@onready var notification_preload = preload("res://ui/notification/notification.tscn")
@onready var storm_timer: Label = $TopHUDMarginContainer/StormTimerContainer/StormTimer
@onready var fp_label: Label = $TopHUDMarginContainer/FPContainer/VBoxContainer/FPLabel
@onready var mini_map_margin_container: MarginContainer = $MiniMapMarginContainer

@export var objective_card: PackedScene
@export var storm_manager: StormManager

func _ready() -> void:
	mini_map_margin_container.visible = false
	
	GameEvents.objectives_picked.connect(on_objectives_picked)
	GameEvents.update_objective_progress.connect(on_update_objective_progress)
	GameEvents.collectable_picked_up.connect(on_collectable_picked_up)
	GameEvents.create_notification.connect(on_create_notification)


func _process(delta: float) -> void:
	storm_timer.text = (
		"%02d:%02d"
		% [storm_manager.get_storm_timer_formatted_minutes(),
		storm_manager.get_storm_timer_formatted_seconds()]
	)
	fp_label.text = (
		"FP: %02d" 
		% GlobalVariables.current_fp + 
		"/" + 
		"%02d" 
		% GlobalVariables.fp_objective)


# Open Map
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		toggle_map()


func toggle_map():
	GameEvents.emit_pause_game(!mini_map_margin_container.visible)
	mini_map_margin_container.visible = !mini_map_margin_container.visible


func check_notification_count():
	var max_notifications: int = 4
	var notification_count = notifications_list.get_child_count()
	
	if notification_count >= max_notifications:
		var difference = (notification_count - max_notifications) + 1
		for i in difference:
			notifications_list.get_child(i).fade_out(0.3, 0.0)


func clear_previous_objectives():
	for card in objectives_container.get_children():
		card.queue_free()


func add_notification(text: String):
	check_notification_count()
	var notification_instance = notification_preload.instantiate() as NotificationLabel
	notifications_list.add_child(notification_instance)
	notification_instance.create_notification(text)


func on_create_notification(text: String):
	add_notification(text)


func on_collectable_picked_up(collectable: CollectableResource):
	add_notification(collectable.collectable_name + " picked up.")


func on_objectives_picked(picked: Array):
	clear_previous_objectives()
	
	for objective in picked:
		var objective_card_instance = objective_card.instantiate() as ObjectiveCard
		objectives_container.add_child(objective_card_instance)
		objective_card_instance.create_card(objective)
		objective_card_instance.assigned_objective = objective


func on_update_objective_progress(objective: ObjectiveResource):
	for card in objectives_container.get_children():
		if card.assigned_objective == objective:
			card.update_progress(objective)

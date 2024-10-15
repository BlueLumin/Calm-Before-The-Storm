# Handles the minimap, displaying resource locations, and the player location.
extends SubViewportContainer

@onready var mini_map_camera: Camera2D = $MiniMapViewport/MiniMapCamera
@onready var sprites: Node2D = $MiniMapViewport/Sprites
@onready var home_marker_point: Sprite2D = $MiniMapViewport/HomeMarkerPoint
@onready var player_marker_point: Sprite2D = $MiniMapViewport/PlayerMarkerPoint
@onready var mini_map_viewport: SubViewport = $MiniMapViewport

var objects: Dictionary = {
	"battery_box": preload("res://scene/object/battery_box/Battery Node.png"),
	"box": preload("res://scene/object/box/Wood Node.png"),
	"dead_animal": preload("res://scene/object/dead_animal/Carrion Node.png"),
	"marsh_pool": preload("res://scene/object/marsh_pool/Water Node.png"),
	"mossy_rock": preload("res://scene/object/mossy_rock/Moss Node.png"),
}

var player: Player
var base: Node2D


func _ready() -> void:
	GameEvents.resouce_spawned.connect(on_resource_spawned)
	
	base = get_tree().get_first_node_in_group("base_node")
	if base == null:
		push_warning(self, " couldn't locate the base node.")
	
	player = get_tree().get_first_node_in_group("player")
	
	if player == null:
		push_warning(self, " cou;dn't locate the player.")


func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	mini_map_camera.global_position = player.global_position
	player_marker_point.global_position = player.global_position
	
	if not is_instance_valid(base):
		return
	
	home_marker_point.global_position = base.global_position


func on_resource_spawned(resource: String, pos: Vector2):
	var sprite_instance = Sprite2D.new()
	sprites.add_child(sprite_instance)
	sprite_instance.hframes = 2
	sprite_instance.texture = objects[resource]
	sprite_instance.global_position = pos

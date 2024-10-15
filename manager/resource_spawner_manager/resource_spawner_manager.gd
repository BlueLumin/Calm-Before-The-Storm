# Spawns random resources at the beginning of the game and "creates" the level.
extends Node2D
class_name ResourceSpawner

signal level_created

## The list of resource objects that can be spawned.
var resources: Dictionary =  { 
	"battery_box": {
		"scene": preload("res://scene/object/battery_box/battery_box.tscn"),
		"markers": [],
		"spawn_range": Vector2i(4, 8),
	},
	"box": {
		"scene": preload("res://scene/object/box/box.tscn"),
		"markers": [],
		"spawn_range": Vector2i(8, 15),
	},
	"dead_animal": {
		"scene": preload("res://scene/object/dead_animal/dead_animal.tscn"),
		"markers": [],
		"spawn_range": Vector2i(6, 10),
	},
	"marsh_pool": {
		"scene": preload("res://scene/object/marsh_pool/marsh_pool.tscn"),
		"markers": [],
		"spawn_range": Vector2i(7, 12),
	},
	"mossy_rock": {
		"scene": preload("res://scene/object/mossy_rock/mossy_rock.tscn"),
		"markers": [],
		"spawn_range": Vector2i(8, 12),
	},
}


func create_level():
	var markers = get_children()
	
	for marker in markers:
		for object in resources:
			if marker.resource_type == object:
				resources[object]["markers"].append(marker)
	
	print("Count of resource spawn points:")
	for object in resources:
		print(object, ": ", resources[object]["markers"].size()) # Print the amount of markers.
		# Get the number of markers in the scene.
		var marker_count: int = resources[object]["markers"].size()
		# Save the spawn range of the object.
		var spawn_range: Vector2i = resources[object]["spawn_range"]
		# For safety, ensure neither of the ranges goes above the marker count.
		spawn_range = Vector2i(min(spawn_range.x, marker_count), min(spawn_range.y, marker_count))
		
		for i in randi_range(spawn_range.x, spawn_range.y):
			# Filter the markers by those that haven't already spawned an object.
			var filtered_markers = resources[object]["markers"].duplicate() as Array
			filtered_markers = filtered_markers.filter(func(marker): return marker.picked == false)
			# Pick a random marker from those that haven't already been picked.
			var chosen_marker = filtered_markers.pick_random() as ResourseSpawnPoint
			
			# Let the mini map know to create a sprite.
			GameEvents.emit_resouce_spawned(resources.find_key(resources[object]), chosen_marker.global_position)
			
			# Create the object on the marker and mark it as "picked".
			chosen_marker.spawn_resource(resources[object]["scene"])
			chosen_marker.picked = true
	
	level_created.emit()
	clear_markers()


func clear_markers():
	for object in resources:
		var marker_list: Array = resources[object]["markers"]
		marker_list.clear()

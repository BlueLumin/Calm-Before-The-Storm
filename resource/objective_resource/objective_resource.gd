extends Resource
class_name ObjectiveResource

@export var id: String ## The objectives id.
@export var display_name: String ## The objectives display name.
@export var objective_description: String ## The description to complete the objective.
@export var completed_description: String ## The description to show once completed.
@export var related_resouce: CollectableResource ## The resouce that must be gathered
@export var quantity_range: Vector2 = Vector2(3, 3) ## The amount that needs to be collected.

var quantity: int = 3 ## How many items need to be picked up (controlled by quantity range)
var progress: int = 0 ## How many items picked up

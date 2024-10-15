# A component that can be added as a child of another node to extend it's functionality.
# Alows node to be interactable.
extends Area2D
class_name InteractComponent

var interact: Callable = func(): pass # The root node will assign a function to this variable.

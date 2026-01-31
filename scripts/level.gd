extends Node2D

class_name Level

var display_target:Node2D
func get_square_id() -> int:
	return display_target.square_id

var whales:Array[Node] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

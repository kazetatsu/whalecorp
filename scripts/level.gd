extends Node2D

class_name Level

var viewport_rect:Rect2

var display_target:Node2D
func get_square_id() -> int:
	return display_target.square_id

var whales:Array[Node] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_rect = get_viewport_rect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

extends Node2D

class_name Employee

var square_id = 0
var level:Node2D

var follow_target:Node2D = null
var viewport_rect:Rect2

func _ready() -> void:
	level = find_parent("*Level*")
	visible = false
	viewport_rect = get_viewport_rect()


func _process(_delta: float) -> void:
	if visible != (level.get_square_id() == square_id):
		visible = !visible

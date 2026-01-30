extends Node2D

var square_id = 0
var level:Node2D

var follow_target:Node2D = null

func _ready() -> void:
	level = find_parent("*Level*")
	visible = false


func _process(_delta: float) -> void:
	if follow_target != null:
		square_id = follow_target.square_id
		position = follow_target.position

	if visible != (level.get_square_id() == square_id):
		visible = !visible

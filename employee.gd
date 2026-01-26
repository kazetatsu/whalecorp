extends Node2D

var square_id = 0
var level:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = find_parent("*Level*")
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if visible != (level.square_id == square_id):
		visible = !visible

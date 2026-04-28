extends Node2D

class_name Level

signal update_room

var viewport_rect:Rect2

var display_target:Node2D
func get_room() -> int:
	return display_target.room

var room:int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_rect = get_viewport_rect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if room != get_room():
		room = get_room()
		update_room.emit()

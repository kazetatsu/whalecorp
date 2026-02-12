extends Node

class_name InputMove

signal toggled
var move = Vector2.ZERO

# LRUD
var _move_pressed = PackedInt32Array([0,0,0,0])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	move.x = 0
	if _move_pressed[0] != 0: move.x -= 1
	if _move_pressed[1] != 0: move.x += 1
	move.y = 0
	if _move_pressed[2] != 0: move.y -= 1
	if _move_pressed[3] != 0: move.y += 1
	move = move.normalized()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		_move_pressed[0] |= 0x01
	if event.is_action_pressed("move_right"):
		_move_pressed[1] |= 0x01
	if event.is_action_pressed("move_up"):
		_move_pressed[2] |= 0x01
	if event.is_action_pressed("move_down"):
		_move_pressed[3] |= 0x01

	if event.is_action_released("move_left"):
		_move_pressed[0] &= 0xFE
	if event.is_action_released("move_right"):
		_move_pressed[1] &= 0xFE
	if event.is_action_released("move_up"):
		_move_pressed[2] &= 0xFE
	if event.is_action_released("move_down"):
		_move_pressed[3] &= 0xFE

	if event.is_action_released("toggle"):
		toggled.emit()

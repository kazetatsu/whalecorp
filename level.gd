extends Node

signal shifted_left
signal shifted_right

var square_id = 0

var president:Node2D
var left_edge:Area2D
var right_edge:Area2D
var timer:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	president = $President
	left_edge = $LeftEdge
	right_edge = $RightEdge
	timer = $Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _forbid_shift() -> void: # Forbid to shift square
	left_edge.set_deferred("monitoring", false)
	right_edge.set_deferred("monitoring", false)
	timer.start()


func _on_left_edge_area_entered(_area: Area2D) -> void:
	_forbid_shift()
	square_id -= 1
	shifted_left.emit()


func _on_right_edge_area_entered(_area: Area2D) -> void:
	_forbid_shift()
	square_id += 1
	shifted_right.emit()


func _on_timer_timeout() -> void: # Allow to shift square
	left_edge.set_deferred("monitoring", true)
	right_edge.set_deferred("monitoring", true)

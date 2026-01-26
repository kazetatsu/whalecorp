extends Node

signal near_enogh

var employees = []

@export var dist_near = 50.0

var level:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = find_parent("*Level*")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_president_request_to_measure(president_pos:Vector2) -> void:
	var nearest_employee:Node2D = null
	var dist_min = dist_near
	for employee in get_children():
		if employee.square_id == level.square_id:
			var dist = president_pos.distance_to(employee.position)
			if dist < dist_min:
				nearest_employee = employee
				dist_min = dist
	if not nearest_employee == null:
		near_enogh.emit()

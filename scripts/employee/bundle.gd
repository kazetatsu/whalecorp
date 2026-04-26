extends Node

class_name EmployeeBundle

@export var dist_near = 50.0

var level:Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = find_parent("Level")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func get_near_employee(target:Node2D) -> Employee:
	var nearest_employee:Employee = null
	var dist_min = dist_near
	for employee in get_children():
		if employee.room == level.get_room():
			var dist = target.position.distance_to(employee.position)
			if dist < dist_min:
				nearest_employee = employee
				dist_min = dist

	if nearest_employee == null: return null
	return nearest_employee

extends Node

signal started_following

@export var dist_near = 50.0

var level:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = find_parent("*Level*")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_president_requested_following(target:Node2D) -> void:
	var nearest_employee:Node2D = null
	var dist_min = dist_near
	for employee in get_children():
		if employee.square_id == level.get_square_id():
			var dist = target.position.distance_to(employee.position)
			if dist < dist_min:
				nearest_employee = employee
				dist_min = dist
	if not nearest_employee == null:
		nearest_employee.follow_target = target
		started_following.emit()


func _on_president_left_follower() -> void:
	for employee in get_children():
		print("hoge")
		employee.follow_target = null

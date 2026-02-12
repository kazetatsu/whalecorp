extends Node

class_name InputInteract

var cb_stack:Array[Callable] = []


func append(callback:Callable) -> void:
	cb_stack.append(callback)


func remove() -> void:
	cb_stack.pop_back()


func _input(event: InputEvent) -> void:
	if event.is_action_released("toggle"):
		cb_stack[-1].call()

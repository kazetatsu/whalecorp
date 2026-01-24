extends Node2D

@export var speed:float
var input_wrapper

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_wrapper = $InputWrapper


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed * $InputWrapper.move * delta

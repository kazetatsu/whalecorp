extends Node2D

signal request_to_measure(position:Vector2)

@export var speed:float
var spawn_pos:Vector2

enum Mode {ALONE, TOGETHER}
var mode = Mode.ALONE

var input_wrapper
var viewport_size:Vector2

func _clip_position() -> void:
	if position.y < 0:
		position.y = 0
	if position.y > viewport_size.y:
		position.y = viewport_size.y


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_wrapper = $InputWrapper
	input_wrapper.toggled.connect(_on_input_wrapper_toggled)
	viewport_size = get_viewport_rect().size
	spawn_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed * input_wrapper.move * delta
	_clip_position()


func _on_level_shifted_left() -> void:
	position.x = viewport_size.x - spawn_pos.x


func _on_level_shifted_right() -> void:
	position.x = spawn_pos.x


func _on_input_wrapper_toggled() -> void:
	if mode == Mode.ALONE:
		request_to_measure.emit(position)
	else:
		$Skin.modulate = Color.WHITE
		mode = Mode.ALONE


func _on_employees_near_enogh() -> void:
	$Skin.modulate = Color.RED
	mode = Mode.TOGETHER

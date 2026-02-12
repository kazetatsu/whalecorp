extends Area2D

signal requested_following(target:Node2D)
signal left_follower

const STATE_ALONE  := 0
const STATE_FOLLOW := 1
var state := STATE_ALONE

var square_id:int = 0
@export var speed:float
var spawn_pos:Vector2

var timer:Timer
var input:InputMove
var viewport_size:Vector2

func _clip_position() -> void:
	if position.y < 0:
		position.y = 0
	if position.y > viewport_size.y:
		position.y = viewport_size.y


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $Timer
	timer.timeout.connect(_on_timer_timeout)
	input = $InputMove
	#input.toggled.connect(_on_input_wrapper_toggled)
	area_entered.connect(_on_area_entered)
	var level:Level = find_parent("Level")
	level.display_target = self
	level.find_child("InputInteract").append(_ask_employees)
	viewport_size = get_viewport_rect().size
	spawn_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed * input.move * delta
	_clip_position()


func _ask_employees() -> void:
	if state == STATE_ALONE:
		requested_following.emit(self)
	else:
		left_follower.emit()
		$Skin.modulate = Color.WHITE
		state = STATE_ALONE


func _on_employees_started_following() -> void:
	$Skin.modulate = Color.RED
	state = STATE_FOLLOW


func _on_area_entered(area: Area2D) -> void:
	if area.name == "RightEdge":
		position.x = spawn_pos.x
		square_id += 1
		set_deferred("monitoring", false)
		timer.start()
	elif area.name == "LeftEdge":
		position.x = viewport_size.x - spawn_pos.x
		square_id -= 1
		set_deferred("monitoring", false)
		timer.start()


func _on_timer_timeout() -> void:
	set_deferred("monitoring", true)

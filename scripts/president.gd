extends Area2D

const STATE_ALONE  := 0
const STATE_FOLLOW := 1
var state := STATE_ALONE

var room:int = 0
@export var speed:float
var spawn_pos:Vector2

var eb:EmployeeBundle
var near_employee:Employee = null

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

	eb = level.find_child("Employees")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed * input.move * delta
	_clip_position()


func _ask_employees() -> void:
	if state == STATE_ALONE:
		near_employee = eb.get_near_employee(self)
		if near_employee != null:
			near_employee.set_follow_target(self)
			$Skin.modulate = Color.RED
			state = STATE_FOLLOW
	else:
		near_employee.set_follow_target(null)
		$Skin.modulate = Color.WHITE
		state = STATE_ALONE


func _on_area_entered(area: Area2D) -> void:
	if area.name == "RightEdge":
		position.x = spawn_pos.x
		room += 1
		set_deferred("monitoring", false)
		timer.start()
	elif area.name == "LeftEdge":
		position.x = viewport_size.x - spawn_pos.x
		room -= 1
		set_deferred("monitoring", false)
		timer.start()


func _on_timer_timeout() -> void:
	set_deferred("monitoring", true)

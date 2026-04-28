extends Employee

@export var speed:float = 500
@export var near_dist:float = 50

var wb:WhaleBridge

#@onready var anim:AnimatedSprite2D = $AnimatedSprite2D
var timer:Timer

const STATE_EAT    := 0
const STATE_WAIT   := 1
const STATE_FOLLOW := 2
var state:int

var is_moving := false

@onready var label:Label = $Label # for debug

func set_follow_target(node:Node2D) -> void:
	if node == null:
		_set_state(STATE_WAIT)
	else:
		_stop_move()
	super.set_follow_target(node)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

	wb = level.find_child("Whales")
	timer = $Timer
	timer.timeout.connect(_on_timer_timeout)
	_set_state(STATE_WAIT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_target != null:
		# Differenece of position
		var dp:Vector2 = follow_target.position - position
		dp.x += (follow_target.room - room) * viewport_rect.size.x

		# Too far from president => Follow president.
		if dp.length_squared() > near_dist ** 2:
			if not is_moving:
				_start_move()
			position += speed * dp.normalized() * delta
			_clip_position()
		# Near enough to president => Eat whale.
		else:
			if is_moving:
				_stop_move()
	else:
		_set_state(STATE_WAIT)

	super._process(delta) # Set visibility.


func _clip_position():
	if position.x < 0:
		if wb.get_whale(room - 1) != null:
			room -= 1
			position.x += viewport_rect.size.x
		else:
			position.x = 0
	elif position.x > viewport_rect.size.x:
		if wb.get_whale(room + 1) != null:
			room += 1
			position.x -= viewport_rect.size.x
		else:
			position.x = viewport_rect.size.x


func _start_move():
	_set_state(STATE_FOLLOW)
	is_moving = true


func _stop_move():
	if wb.get_step(room, position) == Whale.STEP_MEAT:
		_set_state(STATE_EAT)
	else:
		_set_state(STATE_FOLLOW)
	is_moving = false


func _on_timer_timeout():
	wb.eat(room, position)
	_set_state(STATE_FOLLOW)


func _set_state(new_state:int) -> void:
	if new_state == state: return

	if state == STATE_EAT:
		timer.stop()

	state = new_state

	if state == STATE_EAT:
		#anim.play("eat")
		timer.start()
	#elif state == STATE_WAIT:
		#anim.stop()
	#elif state == STATE_FOLLOW:
		#anim.play("follow")

	label.text = "%d" % state

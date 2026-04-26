extends Employee

@export var speed:float = 500
@export var near_dist:float = 50

var wb:WhaleBridge

var anim:AnimatedSprite2D
var timer_eat:Timer
var timer_pull:Timer

const STATE_EAT    := 0
const STATE_WAIT   := 1
const STATE_FOLLOW := 2
const STATE_PULL   := 3
const STATE_CARRY  := 4
const STATE_PUT    := 5
var state:int

var is_moving := false

var block:Node2D = null


func set_follow_target(node:Node2D) -> void:
	if node != null:
		if is_moving: _start_move()
		else: _stop_move()
	else:
		_set_state(STATE_WAIT)
	super.set_follow_target(node)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

	wb = level.find_child("Whales")
	anim = $AnimatedSprite2D
	timer_eat = $TimerEat
	timer_eat.timeout.connect(_on_timer_eat_timeout)
	timer_pull = $TimerPull
	timer_pull.timeout.connect(_on_timer_pull_timeout)
	var area = $Area2D
	area.area_entered.connect(_on_area2d_entered)
	area.area_exited.connect(_on_area2d_exited)
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

	super._process(delta) # Set visibility.


func _clip_position():
	if position.x < 0:
		room -= 1
		position.x += viewport_rect.size.x
	elif position.x > viewport_rect.size.x:
		room += 1
		position.x -= viewport_rect.size.x


func _start_move():
	match state:
		STATE_WAIT, STATE_EAT, STATE_FOLLOW, STATE_PULL:
			_set_state(STATE_FOLLOW)
		STATE_CARRY, STATE_PUT:
			_set_state(STATE_CARRY)
		_: pass
	is_moving = true


func _stop_move():
	if block != null:
		if block.get_parent() != self:
			_set_state(STATE_PULL)
		elif position.y > 400:
			_set_state(STATE_PUT)
		else:
			_set_state(STATE_CARRY)
	elif wb.get_step(room, position) == Whale.STEP_SKIN:
		_set_state(STATE_EAT)
	else:
		_set_state(STATE_FOLLOW)
	is_moving = false


func _on_timer_eat_timeout():
	wb.set_step(room, position, Whale.STEP_MEAT)
	_set_state(STATE_FOLLOW)


func _on_timer_pull_timeout():
	if state == STATE_PULL:
		#whales.lip_block(block.name)
		block.get_child(0).queue_free() # Remove Area2D of block (= no more collision)
		block.reparent(self)
		_set_state(STATE_CARRY)
	elif state == STATE_PUT:
		#whales.put_block(block.name)
		block.queue_free()
		block = null
		_stop_move()


func _set_state(new_state:int) -> void:
	if new_state == state: return

	if state == STATE_EAT:
		timer_eat.stop()
	elif state == STATE_PULL or state == STATE_PUT:
		timer_pull.stop()

	state = new_state

	if state == STATE_EAT:
		anim.play("eat")
		timer_eat.start()
	elif state == STATE_WAIT:
		anim.stop()
	elif state == STATE_FOLLOW:
		anim.play("follow")
	elif state == STATE_PULL:
		timer_pull.start()
		anim.play("eat")
	elif state == STATE_CARRY:
		anim.play("follow")
	elif state == STATE_PUT:
		timer_pull.start()
		anim.stop()


func _on_area2d_entered(other:Area2D):
	if state == STATE_FOLLOW:
		block = other.get_parent()


func _on_area2d_exited(_other:Area2D):
	if state == STATE_FOLLOW:
		block = null

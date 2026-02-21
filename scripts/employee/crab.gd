extends Employee

@export var speed:float = 350
@export var near_dist:float = 50

@export var gravity:float = 700
var vel := Vector2.ZERO
var max_y:float

var whales:WhaleBundle

var anim:AnimatedSprite2D
var timer:Timer

const STATE_EAT   := 0
const STATE_WALK  := 1
const STATE_CRIMB := 2
const STATE_SWIM  := 3
var state:int

@onready var label:Label = $Label # for debug


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	whales = find_parent("Level").find_child("Whales")
	anim = $AnimatedSprite2D
	timer = $Timer
	timer.timeout.connect(_on_timer_timeout)
	max_y = position.y
	_update_state(false)

	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += vel * delta
	_clip_position_and_velocity()

	var progress = whales.get_progress(square_id, position)
	var is_on_whale = (progress != Whale.PROGRESS_CLEAR) \
					or (whales.exists_bone(square_id, position))

	if follow_target != null:
		# Differenece of position
		var dp:Vector2 = follow_target.position - position
		dp.x += (follow_target.square_id - square_id) * viewport_rect.size.x

		# Too far from president => Follow president.
		if dp.length_squared() <= near_dist ** 2:
			if progress == Whale.PROGRESS_MEAT:
				_set_state(STATE_EAT)

			if is_on_whale:
				vel = Vector2.ZERO
			else:
				vel.x = 0
		elif is_on_whale and (position.y < max_y or dp.y < 0):
			vel = speed * dp.normalized()
		elif abs(dp.x) > near_dist:
			vel.x = speed * sign(dp.x)
		else:
			vel.x = 0
	else:
		vel.x = 0

	if not is_on_whale:
		vel.y += gravity * delta

	if state != STATE_EAT:
		_update_state(is_on_whale)

	super._process(delta) # Set visibility.


func _clip_position_and_velocity():
	if position.x < 0:
		square_id -= 1
		position.x += viewport_rect.size.x
	elif position.x > viewport_rect.size.x:
		square_id += 1
		position.x -= viewport_rect.size.x
	if position.y > max_y:
		position.y = max_y
		vel.y = 0


func _on_timer_timeout():
	whales.set_progress(square_id, position, Whale.PROGRESS_BONE)
	_update_state(whales.exists_bone(square_id, position))


func _set_state(new_state:int) -> void:
	if new_state == state: return

	if state == STATE_EAT:
		timer.stop()

	state = new_state

	if state == STATE_EAT:
		timer.start()
	label.text = "%d" % state


func _update_state(is_on_whale:bool) -> void:
	if position.y >= max_y:
		_set_state(STATE_WALK)
	elif is_on_whale:
		_set_state(STATE_CRIMB)
	else:
		_set_state(STATE_SWIM)

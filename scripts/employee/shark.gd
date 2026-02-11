extends Employee

@export var speed:float = 500
@export var near_dist:float = 50

var whales:WhaleBundle

var anim:AnimatedSprite2D
var timer:Timer

const STATE_EAT    := 0
const STATE_WAIT   := 1
const STATE_FOLLOW := 2
var state:int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	whales = find_parent("Level").find_child("Whales")
	anim = $AnimatedSprite2D
	timer = $Timer
	timer.timeout.connect(_on_timer_timeout)
	_set_state(STATE_WAIT)
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_target != null:
		# Differenece of position
		var dp:Vector2 = follow_target.position - position
		dp.x += (follow_target.square_id - square_id) * viewport_rect.size.x

		# Too far from president => Follow president.
		if dp.length_squared() > near_dist ** 2:
			_set_state(STATE_FOLLOW)
			position += speed * dp.normalized() * delta
			_clip_position()
		# Near enough to president => Eat whale.
		else:
			if whales.get_progress(square_id, position) == Whale.PROGRESS_SKIN:
				_set_state(STATE_EAT)
			else:
				_set_state(STATE_FOLLOW)
	else:
		_set_state(STATE_WAIT)

	super._process(delta) # Set visibility.


func _clip_position():
	if position.x < 0:
		square_id -= 1
		position.x += viewport_rect.size.x
	elif position.x > viewport_rect.size.x:
		square_id += 1
		position.x -= viewport_rect.size.x


func _on_timer_timeout():
	whales.set_progress(square_id, position, Whale.PROGRESS_MEAT)
	_set_state(STATE_FOLLOW)


func _set_state(new_state:int) -> void:
	if new_state == state: return

	if state == STATE_EAT:
		timer.stop()

	state = new_state

	if state == STATE_EAT:
		anim.play("eat")
		timer.start()
	elif state == STATE_WAIT:
		anim.stop()
	elif state == STATE_FOLLOW:
		anim.play("follow")

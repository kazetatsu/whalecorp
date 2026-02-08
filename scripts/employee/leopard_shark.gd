extends "res://scripts/employee/base.gd"

@export var speed:float = 500
@export var near_dist:float = 50

var whales:WhaleBundle

var anim:AnimatedSprite2D
var timer:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	whales = find_parent("Level").find_child("Whales")
	anim = $AnimatedSprite2D
	timer = $Timer
	timer.timeout.connect(_on_timer_timeout)
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_target != null:
		# Differenece of position
		var dp:Vector2 = follow_target.position - position
		dp.x += (follow_target.square_id - square_id) * viewport_rect.size.x

		# Too far from president => Follow president.
		if dp.length_squared() > near_dist ** 2:
			position += speed * dp.normalized() * delta
			_clip_position()
			_try_start_animation("follow")
		# Near enough to president => Eat whale.
		else:
			if whales.get_progress(square_id, position) == Whale.PROGRESS_SKIN \
			and _try_start_animation("eat"):
				timer.start()
	else:
		if not timer.is_stopped(): timer.stop()
		if anim.is_playing(): anim.stop()

	super._process(delta) # Set visibility.


func _clip_position():
	if position.x < 0:
		square_id -= 1
		position.x += viewport_rect.size.x
	elif position.x > viewport_rect.size.x:
		square_id += 1
		position.x -= viewport_rect.size.x


func _try_start_animation(animation:String) -> bool:
	if not anim.is_playing() or anim.animation != animation:
		anim.play(animation)
		return true
	return false


func _on_timer_timeout():
	whales.set_progress(square_id, position, Whale.PROGRESS_MEAT)
	anim.stop()

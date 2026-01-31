extends "res://scripts/employee/base.gd"

@export var speed:float = 500
@export var near_dist:float = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		# Near enough to president => Eat whale.
		#else:

	super._process(delta) # Set visibility.


func _clip_position():
	if position.x < 0:
		square_id -= 1
		position.x += viewport_rect.size.x
	elif position.x > viewport_rect.size.x:
		square_id += 1
		position.x -= viewport_rect.size.x

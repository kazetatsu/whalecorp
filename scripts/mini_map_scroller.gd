extends Node2D

var room:int = 0

var original_square:Sprite2D
var squares:Array[Sprite2D]
var width:float
var pivot:float
var num:int
var vel:float

var level:Level
var timer:Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_square = $Square
	width = original_square.get_rect().size.x * original_square.scale.x
	remove_child(original_square)
	var viewport_size = get_viewport_rect().size
	num = ceili(viewport_size.x / width)
	if num % 2 == 0: num += 1
	pivot = 0.5 * viewport_size.x - 0.5 * (num-1) * width # pivot x
	squares = []
	for i in num:
		var square = original_square.duplicate()
		add_child(square)
		square.position.x = pivot + i * width
		squares.append(square)

	level = find_parent("Level")
	timer = $Timer
	timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(dt: float) -> void:
	if not timer.is_stopped():
		position.x -= vel * dt
	else:
		if room < level.get_room():
			_start_shift_right()
		if room > level.get_room():
			_start_shift_left()


func _start_shift_left() -> void:
	timer.start()
	vel = - width / timer.wait_time
	var square = original_square.duplicate()
	add_child(square)
	square.position.x = pivot - width
	squares.insert(0, square)


func _start_shift_right() -> void:
	timer.start()
	vel = width / timer.wait_time
	var square = original_square.duplicate()
	add_child(square)
	square.position.x = pivot + num * width
	squares.append(square)


func _on_timer_timeout() -> void:
	position.x = 0
	if vel > 0: # Slide right
		for square in squares:
			square.position.x -= width
		squares.pop_front().queue_free()
		room += 1
	else:
		for square in squares:
			square.position.x += width
		squares.pop_back().queue_free()
		room -= 1

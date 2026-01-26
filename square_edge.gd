extends Area2D

signal player_leached

var timer:Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_node("../Timer")
	timer.timeout.connect(_on_timer_timeout)
	area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(_area: Area2D) -> void:
	timer.start()
	set_deferred("monitoring", false)
	player_leached.emit()


func _on_timer_timeout() -> void:
	monitoring = true

extends Button

class_name ClearToggle

signal increment(x:int,y:int)

var _x:int
var _y:int

var cnt := 0

func _ready() -> void:
	pressed.connect(_on_pressed)


func _process(delta: float) -> void:
	if cnt < 4:
		cnt += 1
	if cnt == 3:
		var s = get_viewport_rect().size / get_rect().size
		scale.x = s.x / Whale.WIDTH
		scale.y = s.y / Whale.HEIGHT


func _on_pressed() -> void:
	increment.emit(_x, _y)

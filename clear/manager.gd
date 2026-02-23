extends Control

var dx:float
var dy:float

var clear_map:Array[Array]
var toggles:Array[Array]

var whale_name:String

func _ready() -> void:
	toggles = []
	var toggler_original:ClearToggle = $Button
	var d = get_viewport_rect().size
	dx = d.x / Whale.WIDTH
	dy = d.y / Whale.HEIGHT
	for x in Whale.WIDTH:
		toggles.append([])
		for y in Whale.HEIGHT:
			var toggler = toggler_original.duplicate()
			add_child(toggler)
			toggler.position.x = x * dx
			toggler.position.y = y * dy
			toggler._x = x
			toggler._y = y
			toggles[x].append(toggler)
			toggler.increment.connect(_on_toggler_increment)
	toggler_original.queue_free()

	clear_map = []
	for x in Whale.WIDTH:
		clear_map.append([])
		for y in Whale.HEIGHT:
			clear_map[x].append(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_toggler_increment(x:int, y:int) -> void:
	clear_map[x][y] += 1
	clear_map[x][y] %= 4
	var text:String
	match clear_map[x][y]:
		Whale.PROGRESS_SKIN:
			text = "SKIN"
		Whale.PROGRESS_MEAT:
			text = "MEAT"
		Whale.PROGRESS_BONE:
			text = "BONE"
		Whale.PROGRESS_CLEAR:
			text = "CLEAR"
	toggles[x][y].text = text


func _on_spawner_showed() -> void:
	for x in Whale.WIDTH:
		for y in Whale.HEIGHT:
			toggles[x][y].hide()


func _on_spawner_hided(_whale_name:String) -> void:
	whale_name = _whale_name
	for x in Whale.WIDTH:
		for y in Whale.HEIGHT:
			toggles[x][y].show()

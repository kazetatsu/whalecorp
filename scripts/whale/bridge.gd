extends Node2D

class_name WhaleBridge

var level:Level

var whales:Array[Whale]

var wv_original:WhaleVis
var wvs:Array[WhaleVis]

func eat(room:int, position:Vector2) -> void:
	var room_whales:Array[Whale] = get_all_whales(room)
	if len(room_whales) == 0: return

	var grid = _get_nearest_grid(position)
	for i in len(room_whales):
		var step = room_whales[i].get_step(grid.x, grid.y)
		if step != Whale.STEP_GOAL:
			room_whales[i].set_step(grid.x, grid.y, step+1)
			wvs[i].set_step(grid.x, grid.y, step+1)
			return


func get_step(room:int, position:Vector2) -> int:
	var room_whales:Array[Whale] = get_all_whales(room)
	if len(room_whales) == 0:
		return Whale.STEP_GOAL

	var grid = _get_nearest_grid(position)
	for whale in room_whales:
		var step = whale.get_step(grid.x, grid.y)
		if step != Whale.STEP_GOAL:
			return step

	return Whale.STEP_GOAL


func get_whale(room:int) -> Whale:
	for i in len(whales):
		if whales[i].can_eat and whales[i].room == room:
			return whales[i]
	return null


func get_all_whales(room:int) -> Array[Whale]:
	var ret:Array[Whale] = []
	for i in len(whales):
		if whales[i].can_eat and whales[i].room == room:
			ret.append(whales[i])
	return ret


func exists_bone(room:int, position:Vector2) -> bool:
	var whale:Whale = get_whale(room)
	if whale == null: return false
	var grid = _get_nearest_grid(position)
	return whale.exists_bone(grid.x, grid.y)


func _get_nearest_grid(position:Vector2) -> Vector2i:
	var p = position / get_viewport_rect().size
	return Vector2i(
		floori(p.x * Whale.WIDTH),
		floori(p.y * Whale.HEIGHT)
	)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = find_parent("Level")
	var w = Whale.new("debug0")
	w.specie = "debug"
	w.room = 1
	w.from_specie()
	whales = [w]

	wv_original = $Vis
	wvs = [wv_original]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _show_whale(room:int) -> void:
	var room_whales = get_all_whales(level.get_room())
	var n_new = len(room_whales)
	print(n_new)
	var n_old = len(wvs)

	if n_new == 0:
		for i in n_old - 1:
			wvs.pop_front().queue_free()
		hide()
		return

	for i in n_new - n_old:
		var wv = wv_original.duplicate()
		wv.reparent(self)
		wvs.push_front(wv)
	for i in n_old - 1 - n_new:
		wvs.pop_front().queue_free()

	for i in n_new:
		wvs[i].set_whale(room_whales[i])
		wvs[i].reinit()

	show()


func _on_level_update_room() -> void:
	_show_whale(level.get_room())

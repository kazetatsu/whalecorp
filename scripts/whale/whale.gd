extends Resource

class_name Whale

const WIDTH  := 16
const HEIGHT := 12

const STEP_SKIN := 0
const STEP_MEAT := 1
const STEP_BONE := 2
const STEP_NONE := 3
const STEP_GOAL := 3

var name:String
var specie:String
var room:int = -1
var position:Vector2 = Vector2.ZERO
var scale:float = 1
var offset:Vector2i = Vector2i.ZERO
var can_eat:bool = true
var goal_steps:PackedByteArray
var prgr_steps:PackedByteArray # progress

func _init(name:String) -> void:
	self.name = name


func _to_string() -> String:
	return to_str(true, true)


func to_str(
	include_specie:bool = true,
	include_specie_consts:bool = false,
) -> String:
	var ret = ""
	if include_specie:
		ret += "specie\n%s\n" % specie
	if room >= 0:
		ret += "room\n%d\n" % room
	ret += "position\n%f,%f\n" % [position.x, position.y]
	if include_specie_consts:
		ret += "scale\n%f\n" % scale
	if offset != Vector2i.ZERO:
		ret += "offset\n%d,%d\n" % [offset.x, offset.y]
	ret += "can_eat\n"
	ret += "true\n" if can_eat else "false\n"
	if include_specie_consts:
		ret += "goal_steps\n"
		ret += _steps_to_str(goal_steps)
	ret += "prgr_steps\n"
	ret += _steps_to_str(prgr_steps)
	return ret


func from_specie() -> void:
	var f = FileAccess.open(
		"res://whales/%s/default.txt" % specie,
		FileAccess.READ)
	from_file(f)
	f.close()


func from_file(f:FileAccess) -> void:
	while true:
		var flag = f.get_line()
		if flag == null: break
		match flag:
			"specie":
				specie = f.get_line().strip_edges()
			"room":
				room = int(f.get_line().strip_edges())
			"position":
				var strs = f.get_line().strip_edges().split(",")
				position = Vector2(float(strs[0].strip_edges()), float(strs[1].strip_edges()))
			"scale":
				scale = float(f.get_line().strip_edges())
			"offset":
				var strs = f.get_line().strip_edges().split(",")
				offset = Vector2i(int(strs[0].strip_edges()), int(strs[1].strip_edges()))
			"can_eat":
				can_eat = (f.get_line().strip_edges() == "true")
			"goal_steps":
				goal_steps = _load_steps(f)
			"prgr_steps":
				prgr_steps  = _load_steps(f)
			"end", "": break
			_: continue


func get_step(x:int, y:int) -> int:
		var p = _seek_steps(prgr_steps, x, y)
		var g = _seek_steps(goal_steps, x, y)
		if p >= g:
			return STEP_GOAL
		else:
			return p


func set_step(x:int, y:int, step:int) -> void:
	_write_steps(prgr_steps, x, y, step)


func exists_bone(x:int, y:int) -> bool:
	return _seek_steps(goal_steps, x, y) == STEP_GOAL


func get_image_texture(step:int) -> ImageTexture:
	var path = "res://whales/%s/" % specie
	match step:
		STEP_SKIN:
			path += "skin.png"
		STEP_MEAT:
			path += "meat.png"
		STEP_BONE:
			path += "bone.png"
		STEP_GOAL:
			path += "goal.png"
		_:
			return null
	return load(path)


func _load_steps(f:FileAccess) -> PackedByteArray:
	var ret:Array[int] = []
	for y in HEIGHT:
		var s = f.get_line().strip_edges()
		for x in range(0, WIDTH, 4):
			var r:int = 0
			r |= int(s[x])
			r <<= 2
			r |= int(s[x + 1])
			r <<= 2
			r |= int(s[x + 2])
			r <<= 2
			r |= int(s[x + 3])
			ret.append(r)
	return PackedByteArray(ret)


func _steps_to_str(steps:PackedByteArray) -> String:
	var ret = ""
	for y in HEIGHT:
		for x in WIDTH:
			ret += "%d" % _seek_steps(steps, x, y)
		ret += "\n"
	return ret


func _seek_steps(steps:PackedByteArray, x:int, y:int) -> int:
	var i:int = y * (WIDTH/4) + x / 4
	var s:int = 2 * (3 - (x % 4))
	return (steps[i] >> s) & 0x03


func _write_steps(steps:PackedByteArray, x:int, y:int, step:int):
	var i:int = y * (WIDTH/4) + x / 4
	var s:int = 2 * (3 - (x % 4))
	# delete old progress
	var mask:int = ~(0x03 << s)
	steps[i] &= mask
	# write new progress
	mask = (step & 0x03) << s
	steps[i] |= mask

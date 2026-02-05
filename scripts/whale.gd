extends Resource

class_name Whale

const WIDTH  := 16
const HEIGHT := 12

const PROGRESS_SKIN  := 0
const PROGRESS_MEAT  := 1
const PROGRESS_BONE  := 2
const PROGRESS_CLEAR := 3


var progress_map:PackedByteArray
var clear_map:PackedByteArray


func _init() -> void:
	var progress_arr = []
	var clear_arr = []
	for i in Whale.HEIGHT * Whale.WIDTH:
		progress_arr.append(0x00)
		clear_arr.append(0xFF)
	progress_map = PackedByteArray(progress_arr)
	clear_map    = PackedByteArray(clear_arr)


func _to_string() -> String:
	var p = []
	for r in HEIGHT:
		var q = []
		for c in WIDTH:
			q.append(get_progress(r,c))
		p.append(q)
	return var_to_str(p)


func get_progress(row:int, col:int) -> int:
	var i = row * 4 + col / 4
	var s = (col % 4) * 2
	var progress = (progress_map[i] >> s) & 0x03
	var clear    = (clear_map[i]    >> s) & 0x03
	if progress >= clear:
		return PROGRESS_CLEAR
	else:
		return progress


func set_progress(row:int, col:int, progress:int) -> void:
	var i = row * 4 + col / 4
	var s = (col % 4) * 2
	# Erase old progress
	progress_map[i] &= ~(0x03 << s)
	# Write new progress
	progress_map[i] |= (progress & 0x03) << s

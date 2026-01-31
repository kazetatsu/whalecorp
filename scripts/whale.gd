extends Resource

class_name Whale

const WIDTH  := 16
const HEIGHT := 12

const PROGRESS_SKIN  := 0
const PROGRESS_MEAT  := 1
const PROGRESS_BONE  := 2
const PROGRESS_CLEAR := 3
const PROGRESS_INACTIVE := -1

var raw_progress:PackedByteArray


func _init() -> void:
	var p = []
	for i in 24:
		p.append_array([0x00,0x00,0x00])
	raw_progress = PackedByteArray(p)


func _to_string() -> String:
	var p = []
	for r in HEIGHT:
		var q = []
		for c in WIDTH:
			q.append(get_progress(r,c))
		p.append(q)
	return var_to_str(p)


func get_progress(row:int, col:int) -> int:
	var i = row * 6 + (col / 8) * 3
	var s = col % 8
	if (raw_progress[i] >> s) & 0x01 == 0x01:
		return PROGRESS_INACTIVE
	return ((raw_progress[i + 1] >> s) & 0x01) \
			| (((raw_progress[i + 2] >> s) & 0x01) << 1)


func set_progress(row:int, col:int, progress:int) -> void:
	var i = row * 6 + (col / 8) * 3
	var s = col % 8
	if progress == PROGRESS_INACTIVE:
		raw_progress[i] |= 0x01 << s
		return
	var mask = ~(0x01 << s)
	raw_progress[i]   &= mask
	raw_progress[i+1] &= mask
	raw_progress[i+2] &= mask

	raw_progress[i+1] |= (0x01 & progress) << s
	raw_progress[i+2] |= ((0x02 & progress) >> 1) << s

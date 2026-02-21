extends Resource

class_name Whale

const WIDTH  := 16
const HEIGHT := 12

const PROGRESS_SKIN  := 0
const PROGRESS_MEAT  := 1
const PROGRESS_BONE  := 2
const PROGRESS_CLEAR := 3

var position:Vector2
var scale:float

var progress_map:PackedByteArray
var clear_map:PackedByteArray

var name:String

class WhaleBlock:
	var position:Vector2
	var name:String
	func _to_string() -> String:
		return "(%s at %.1f,%.1f)" % [name, position.x, position.y]

var blocks:Array[WhaleBlock]


func _init(name:String) -> void:
	self.name = name
	blocks = []
	var file = FileAccess.open("res://whales/" + name + "/params.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var res = json.parse(file.get_as_text())
		file.close()
		if res == OK:
			var transform = json.data["transform"]
			position = Vector2(transform[0], transform[1])
			scale = transform[2]
			for raw_block:Array in json.data["blocks"]:
				var block = WhaleBlock.new()
				block.name = raw_block[0]
				block.position = Vector2(raw_block[1], raw_block[2])
				blocks.append(block)
	print(blocks)
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


func get_progress(x:int, y:int) -> int:
	var i = y * 4 + x / 4
	var s = (x % 4) * 2
	var progress = (progress_map[i] >> s) & 0x03
	var clear    = (clear_map[i]    >> s) & 0x03
	if progress >= clear:
		return PROGRESS_CLEAR
	else:
		return progress


func set_progress(x:int, y:int, progress:int) -> void:
	var i = y * 4 + x / 4
	var s = (x % 4) * 2
	# Erase old progress
	progress_map[i] &= ~(0x03 << s)
	# Write new progress
	progress_map[i] |= (progress & 0x03) << s


func get_clear_progress(x:int, y:int) -> int:
	var i = y * 4 + x / 4
	var s = (x % 4) * 2
	return (clear_map[i] >> s) & 0x03

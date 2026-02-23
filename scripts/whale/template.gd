extends Whale

func _init(name:String) -> void:
	super._init(name)
	var clear_map_arr = [{}]
	for x:int in WIDTH/4:
		for y:int in HEIGHT:
			var i:int = y*4 + x
			clear_map[i] = clear_map_arr[x][y] & 0x03
			for s:int in range(1,4):
				clear_map[i] <<= 2
				clear_map[i] |= clear_map_arr[x+s][y] & 0x03

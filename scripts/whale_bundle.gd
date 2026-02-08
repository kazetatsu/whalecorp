extends Node2D

class_name WhaleBundle

var level:Level

var whales:Dictionary[int,Whale]

var _square_id = null

var masks:Array[Sprite2D]

func set_progress(square_id:int, position:Vector2, progress:int) -> void:
	if not whales.has(square_id): return
	var grid = _get_nearest_grid(position)
	whales[square_id].set_progress(grid.x, grid.y, progress)

	if square_id != _square_id: return
	for i in progress:
		var mask_img = masks[i].texture.get_image()
		mask_img.set_pixel(grid.x, grid.y, Color.TRANSPARENT)
		masks[i].texture.set_image(mask_img)


func get_progress(square_id:int, position:Vector2) -> int:
	if not whales.has(square_id):
		return Whale.PROGRESS_CLEAR
	var grid = _get_nearest_grid(position)
	return whales[square_id].get_progress(grid.x, grid.y)


func _get_nearest_grid(position:Vector2) -> Vector2i:
	var p = position / get_viewport_rect().size
	return Vector2i(
		floori(p.x * Whale.WIDTH),
		floori(p.y * Whale.HEIGHT)
	)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = find_parent("*Level*")
	whales = {1: Whale.new()}
	#whales[1].set_progress(7, 7, Whale.PROGRESS_BONE)
	#whales[1].set_progress(6, 6, Whale.PROGRESS_MEAT)
	#whales[1].set_progress(6, 8, Whale.PROGRESS_BONE)

	# Create mask image for each layer of whale
	var viewport_rect = get_viewport_rect()
	masks = [$Skin, $Meat, $Bone]
	for mask in masks:
		var mask_img = Image.create(Whale.WIDTH, Whale.HEIGHT, false, Image.FORMAT_LA8)
		mask_img.fill(Color.WHITE)
		mask.texture = ImageTexture.create_from_image(mask_img)
		var mask_rect = mask.get_rect()
		var positions:Array[Vector2] = []
		var scales:Array[Vector2] = []
		for i:int in mask.get_child_count():
			var grand_child = mask.get_child(i)
			positions.append(grand_child.global_position)
			scales.append(grand_child.global_scale)
		mask.scale = viewport_rect.size / mask_rect.size
		for i:int in mask.get_child_count():
			var grand_child = mask.get_child(i)
			grand_child.global_position = positions[i]
			grand_child.global_scale = scales[i]

	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Initialize masks' texture.
	if level.get_square_id() != _square_id:
		_square_id = level.get_square_id()
		if whales.has(_square_id):
			var whale = whales[_square_id]
			var mask_imgs:Array[Image] = []
			for mask in masks:
				mask_imgs.append(mask.texture.get_image())
			for r in Whale.HEIGHT:
				for c in Whale.WIDTH:
					for i in whale.get_progress(r,c):
						mask_imgs[i].set_pixel(r, c, Color.TRANSPARENT)
			for i in 3:
				masks[i].texture.set_image(mask_imgs[i])
			show()
		else:
			hide()

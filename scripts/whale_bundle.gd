extends Node2D

class_name WhaleBundle

var level:Level

var whales:Dictionary[int,Whale]

var _square_id = null

var masks:Array[Sprite2D]
var sprites:Array[Sprite2D]
var blocks:Node2D

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


func lip_block(block_name:String) -> void:
	if not whales.has(_square_id): return

	var i = 0
	for block in whales[_square_id].blocks:
		if block.name == block_name:
			break
		i += 1
	whales[_square_id].blocks.remove_at(i)


func put_block(block_name:String) -> void:
	whales[_square_id] = Whale.new(block_name)
	_show_whale()
	show()


func _get_nearest_grid(position:Vector2) -> Vector2i:
	var p = position / get_viewport_rect().size
	return Vector2i(
		floori(p.x * Whale.WIDTH),
		floori(p.y * Whale.HEIGHT)
	)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = find_parent("Level")
	whales = {1: Whale.new("debug_whale")}

	# Create mask image for each layer of whale
	var viewport_rect = get_viewport_rect()
	masks = [$Skin, $Meat, $Bone]
	for mask in masks:
		var mask_img = Image.create(Whale.WIDTH, Whale.HEIGHT, false, Image.FORMAT_LA8)
		mask_img.fill(Color.WHITE)
		mask.texture = ImageTexture.create_from_image(mask_img)
		mask.scale = viewport_rect.size / mask.get_rect().size

	sprites = [$Skin/Whale, $Meat/Whale, $Bone/Whale, $ClearWhale]
	blocks = $Blocks

	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Initialize masks' texture.
	if level.get_square_id() != _square_id:
		_square_id = level.get_square_id()
		for old_block in blocks.get_children():
			old_block.queue_free()

		# Reinitialize
		if whales.has(_square_id):
			_show_whale()
			show()
		else:
			hide()


func _show_whale() -> void:
	var whale = whales[_square_id]
	var dir = "res://whales/%s/" % whale.name

	# Masks
	var mask_imgs:Array[Image] = []
	for mask in masks:
		mask_imgs.append(mask.texture.get_image())
	for y in Whale.HEIGHT:
		for x in Whale.WIDTH:
			var progress = whale.get_progress(x,y)
			for i in 3:
				if i < progress:
					mask_imgs[i].set_pixel(x, y, Color.TRANSPARENT)
				else:
					mask_imgs[i].set_pixel(x, y, Color.WHITE)
	for i in 3:
		masks[i].texture.set_image(mask_imgs[i])

	# Sprites
	sprites[0].texture = load(dir + "skin.png")
	sprites[1].texture = load(dir + "meat.png")
	sprites[2].texture = load(dir + "bone.png")
	sprites[3].texture = load(dir + "clear.png")
	var s = Vector2(whale.scale, whale.scale)
	for sprite in sprites:
		sprite.global_position = whale.position
		sprite.global_scale = s

	# Blocks
	for block:Whale.WhaleBlock in whale.blocks:
		var node:Node2D = load(dir + "%s.tscn" % block.name).instantiate()
		node.position = block.position
		node.name = block.name
		blocks.add_child(node)

extends Node2D

class_name WhaleBridge

var level:Level

var whales:Array[Whale]

var masks:Array[Sprite2D]
var sprites:Array[Sprite2D]

func set_step(room:int, position:Vector2, step:int) -> void:
	var whale:Whale = get_whale(room)
	if whale == null: return

	var grid = _get_nearest_grid(position)

	whale.set_step(grid.x, grid.y, step)

	if room != level.get_room(): return

	for i in whale.get_step(grid.x, grid.y):
		var mask_img = masks[i].texture.get_image()
		mask_img.set_pixel(grid.x, grid.y, Color.TRANSPARENT)
		masks[i].texture.set_image(mask_img)


func get_step(room:int, position:Vector2) -> int:
	var whale:Whale = get_whale(room)
	if whale == null:
		return Whale.STEP_GOAL

	var grid = _get_nearest_grid(position)
	return whale.get_step(grid.x, grid.y)


func get_whale(room:int) -> Whale:
	for i in range(len(whales)-1, -1, -1):
		if whales[i].room == room:
			return whales[i]
	return null


func exists_bone(room:int, position:Vector2) -> bool:
	var whale:Whale = get_whale(room)
	if whale == null: return false
	var grid = _get_nearest_grid(position)
	return whale._seek_steps(whale.goal_steps, grid.x, grid.y) == Whale.STEP_GOAL


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

	# Create mask image for each layer of whale
	var viewport_rect = get_viewport_rect()
	masks = [$Skin, $Meat, $Bone]
	for mask in masks:
		var mask_img = Image.create(Whale.WIDTH, Whale.HEIGHT, false, Image.FORMAT_LA8)
		mask_img.fill(Color.WHITE)
		mask.texture = ImageTexture.create_from_image(mask_img)
		mask.scale = viewport_rect.size / mask.get_rect().size

	sprites = [$Skin/Whale, $Meat/Whale, $Bone/Whale, $ClearWhale]

	show_whale(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func show_whale(room:int) -> void:
	var whale = get_whale(room)
	if whale == null:
		hide()
		return

	# Masks
	var mask_imgs:Array[Image] = []
	for mask in masks:
		mask_imgs.append(mask.texture.get_image())
	for y in Whale.HEIGHT:
		for x in Whale.WIDTH:
			var step = whale.get_step(x,y)
			for i in 3:
				if i < step:
					mask_imgs[i].set_pixel(x, y, Color.TRANSPARENT)
				else:
					mask_imgs[i].set_pixel(x, y, Color.WHITE)
	for i in 3:
		masks[i].texture.set_image(mask_imgs[i])

	# Sprites
	sprites[0].texture = whale.get_image_texture(Whale.STEP_BONE)
	sprites[1].texture = whale.get_image_texture(Whale.STEP_MEAT)
	sprites[2].texture = whale.get_image_texture(Whale.STEP_BONE)
	sprites[3].texture = whale.get_image_texture(Whale.STEP_GOAL)
	for sprite in sprites:
		sprite.global_position = whale.position
		sprite.global_scale = whale.scale * Vector2.ONE

	show()


func _on_level_update_room() -> void:
	show_whale(level.get_room())

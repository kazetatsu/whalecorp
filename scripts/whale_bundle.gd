extends Node2D

var level:Level

var whales:Dictionary[int,Whale]

var square_id = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level = find_parent("*Level*")
	whales = {1: Whale.new()}
	#whales[1].set_progress(7, 7, Whale.PROGRESS_BONE)
	#whales[1].set_progress(6, 6, Whale.PROGRESS_MEAT)
	#whales[1].set_progress(6, 8, Whale.PROGRESS_BONE)

	# Create mask image for each layer of whale
	var viewport_rect = get_viewport_rect()
	for child:Sprite2D in get_children():
		var mask = Image.create(Whale.WIDTH, Whale.HEIGHT, false, Image.FORMAT_LA8)
		mask.fill(Color.WHITE)
		child.texture = ImageTexture.create_from_image(mask)
		var mask_rect = child.get_rect()
		var grand_child:Node2D = child.get_child(0)
		var p = grand_child.global_position
		var s = grand_child.global_scale
		child.scale = viewport_rect.size / mask_rect.size
		grand_child.global_position = p
		grand_child.global_scale = s

	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if level.get_square_id() != square_id:
		square_id = level.get_square_id()
		if whales.has(square_id):
			var whale = whales[square_id]
			var mask_texs:Array[ImageTexture] = [$Skin.texture, $Meat.texture, $Bone.texture]
			var mask_imgs:Array[Image] = []
			for tex in mask_texs:
				mask_imgs.append(tex.get_image())
			for r in Whale.HEIGHT:
				for c in Whale.WIDTH:
					for i in whale.get_progress(r,c):
						mask_imgs[i].set_pixel(r, c, Color.TRANSPARENT)
			for i in 3:
				mask_texs[i].set_image(mask_imgs[i])
			show()
		else:
			hide()

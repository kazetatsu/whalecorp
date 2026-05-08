extends Node2D

class_name WhaleVis

var masks:Array[Sprite2D]
var sprites:Array[Sprite2D]

var whale:Whale

func set_whale(whale:Whale) -> void:
	self.whale = whale


func reinit() -> void:
	var mask_imgs = []
	for i in 3:
		mask_imgs.append(masks[i].texture.get_image())

	for x in Whale.WIDTH:
		for y in Whale.HEIGHT:
			var step = whale.get_step(x, y)
			for i in 3:
				var color:Color
				if i < step: color = Color.TRANSPARENT
				else:        color = Color.WHITE
				mask_imgs[i].set_pixel(x, y, color)

	var d = get_viewport_rect().size.x / Whale.WIDTH
	for i in 3:
		masks[i].texture.set_image(mask_imgs[i])
		masks[i].global_position = whale.offset * d

	for i in 4:
		sprites[i].global_position = whale.position + d * whale.offset
		sprites[i].global_scale = whale.scale * Vector2.ONE
		sprites[i].texture = whale.get_image_texture(i)


func set_step(x:int, y:int, step:int) -> void:
	if x < 0 or x >= Whale.WIDTH or y < 0 or y >= Whale.HEIGHT:
		return

	for i in step:
		var mask_img = masks[i].texture.get_image()
		mask_img.set_pixel(x, y, Color.TRANSPARENT)
		masks[i].texture.set_image(mask_img)


func _ready() -> void:
	masks = [$Skin, $Meat, $Bone]
	sprites = [$Skin/Whale, $Meat/Whale, $Bone/Whale, $ClearWhale]

	# Create mask image for each layer of whale
	var viewport_rect = get_viewport_rect()
	for mask in masks:
		var mask_img = Image.create(Whale.WIDTH, Whale.HEIGHT, false, Image.FORMAT_LA8)
		mask_img.fill(Color.WHITE)
		mask.texture = ImageTexture.create_from_image(mask_img)
		mask.scale = viewport_rect.size / mask.get_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

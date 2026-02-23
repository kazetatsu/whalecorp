extends Sprite2D

var p := Vector2.ZERO
var s:float = 0

var _whale_name:String
var progress:int = 0

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	position += p
	scale += s * 0.01 * Vector2.ONE


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") or event.is_action_released("ui_down"):
		p.y -= 1
	elif event.is_action_released("ui_up") or event.is_action_pressed("ui_down"):
		p.y += 1
	elif event.is_action_pressed("ui_left") or event.is_action_released("ui_right"):
		p.x -= 1
	elif event.is_action_released("ui_left") or event.is_action_pressed("ui_right"):
		p.x += 1
	elif event.is_action_pressed("ui_home") or event.is_action_released("ui_end"):
		s += 1
	elif event.is_action_pressed("ui_end") or event.is_action_released("ui_home"):
		s -= 1
	elif event.is_action_pressed("ui_select"):
		progress += 1
		progress %= 4
		var path = "res://whales/" + _whale_name + "/{}.png"
		if progress == Whale.PROGRESS_SKIN:
			path = path.format(["skin"])
		elif progress == Whale.PROGRESS_MEAT:
			path = path.format(["meat"])
		elif progress == Whale.PROGRESS_BONE:
			path = path.format(["bone"])
		elif progress == Whale.PROGRESS_CLEAR:
			path = path.format(["clear"])
		texture = ImageTexture.create_from_image(load(path))


func _on_spawner_hided(whale_name: String) -> void:
	if whale_name == "": return

	_whale_name = whale_name
	progress = 0
	var img = Image.load_from_file("res://whales/%s/skin.png" % _whale_name)
	texture = ImageTexture.create_from_image(img)

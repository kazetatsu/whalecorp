extends TextEdit

class_name ClearSpawner

signal showed
signal hided(whale_name:String)

func _ready() -> void:
	hide()


func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if visible:
			hide()
			var dir = "res://whales/%s/" % text
			var exists = FileAccess.file_exists(dir + "skin.png") \
					and FileAccess.file_exists(dir + "meat.png") \
					and FileAccess.file_exists(dir + "bone.png") \
					and FileAccess.file_exists(dir + "clear.png")
			if exists:
				hided.emit(text)
			else:
				hided.emit("")
		else:
			show()
			showed.emit()

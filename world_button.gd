extends Button


@export var world: String
var is_pressed = false

func _on_pressed():
	is_pressed = true

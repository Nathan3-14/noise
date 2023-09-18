extends Control

@export var texture: Texture


# Called when the node enters the scene tree for the first time.
func _ready():
	$Item.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

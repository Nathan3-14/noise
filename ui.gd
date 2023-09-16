extends Control


@export var x = 0.0
@export var y = 0.0
@export var z = 0.0

@onready var positions = $MarginContainer/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	positions.get_node("X").text = "X: " + str(x)
	positions.get_node("Y").text = "Y: " + str(y)
	positions.get_node("Z").text = "Z: " + str(z)

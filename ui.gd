extends Control


@export var x = 0.0
@export var y = 0.0
@export var z = 0.0

@onready var positions = $MarginContainer/VBoxContainer
@onready var inventory = $Inventory
@onready var player = get_parent().get_parent()


func _ready():
	change_item(player.selected_item)

func change_item(index: float):
	$Inventory.get_child(index).get_node("Selected").visible = not $Inventory.get_child(index).get_node("Selected").visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	positions.get_node("X").text = "X: " + str(x)
	positions.get_node("Y").text = "Y: " + str(y)
	positions.get_node("Z").text = "Z: " + str(z)
	var changed: bool
	
	if Input.is_action_just_pressed("inv_scroll_up"):
		changed = true
		change_item(player.selected_item)
		player.selected_item += 1
	elif Input.is_action_just_pressed("inv_scroll_down"):
		changed = true
		change_item(player.selected_item)
		player.selected_item -= 1
	
	if player.selected_item > 1 or player.selected_item < 0:
		player.selected_item = 0
	if changed:
		change_item(player.selected_item)
	
	print($Inventory.get_child(player.selected_item))
		

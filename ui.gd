extends Control


@export var x = 0.00
@export var y = 0.00
@export var z = 0.00
@export var block_x = 0.0
@export var block_y = 0.0
@export var block_z = 0.0

@onready var player_positions = $Coords/HBoxContainer/Player
@onready var block_positions  = $Coords/HBoxContainer/Block
@onready var inventory = $Inventory
@onready var player = get_parent().get_parent()


func _ready():
	change_item(player.selected_item)

func change_item(index: float):
	$Inventory.get_child(index).get_node("Selected").visible = not $Inventory.get_child(index).get_node("Selected").visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_positions.get_node("X").text = "X: " + str(x)
	player_positions.get_node("Y").text = "Y: " + str(y)
	player_positions.get_node("Z").text = "Z: " + str(z)
	block_positions.get_node("X").text = "Block X: " + str(block_x)
	block_positions.get_node("Y").text = "Block Y: " + str(block_y)
	block_positions.get_node("Z").text = "Block X: " + str(block_z)
	
	var changed: bool
	
	if Input.is_action_just_pressed("inv_scroll_down"):
		changed = true
		change_item(player.selected_item)
		player.selected_item += 1
	elif Input.is_action_just_pressed("inv_scroll_up"):
		changed = true
		change_item(player.selected_item)
		player.selected_item -= 1
	
	if Input.is_action_just_pressed("inv_select_1"):
		changed = true
		change_item(player.selected_item)
		player.selected_item = 0
	if Input.is_action_just_pressed("inv_select_2"):
		changed = true
		change_item(player.selected_item)
		player.selected_item = 1
	if Input.is_action_just_pressed("inv_select_3"):
		changed = true
		change_item(player.selected_item)
		player.selected_item = 2
	
	
	
	if player.selected_item > 2:
		player.selected_item = 0
	if player.selected_item < 0:
		player.selected_item = 2
	if changed:
		change_item(player.selected_item)
	
	

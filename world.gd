extends Node3D

@export var noise_scale = 5

var grass = preload("res://grass_block.tscn")
# mesh by 'Render at Night'
var dirt = preload("res://dirt_block.tscn")
var noise_generator = FastNoiseLite.new()

func _ready():
	noise_generator.seed = 1234
	
	var current_noise = generatePerlinNoise(50, 50)
	
	for x in range(0, 50):
		var row = current_noise[x]
		for y in range(0, 50):
			var grass_inst = grass.instantiate()
			add_child(grass_inst)
			grass_inst.position.x = x
			grass_inst.position.y = snappedi(row[y] * noise_scale, 1)
			grass_inst.position.z = y
			
			var dirt_inst = dirt.instantiate()
			add_child(dirt_inst)
			dirt_inst.position.x = x
			dirt_inst.position.y = snappedi(row[y] * noise_scale, 1)-1
			dirt_inst.position.z = y
			
			

func generatePerlinNoise(width, height):
	var noise_list = []
	
	for x in range(width):
		var row = []
		for y in range(height):
			var noise_value = noise_generator.get_noise_2d(x * noise_scale, y * noise_scale)
			row.append(noise_value)
		noise_list.append(row)
	
	return noise_list


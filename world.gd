extends Node3D

@export var noise_scale = 5
var noise_generator = FastNoiseLite.new()

# Define the dimensions of your 3D world
var world_width = 32
var world_height = 16  # actual height
var world_depth = 32
var surface_height = 10

var air   = preload("res://air.tscn")
var dirt  = preload("res://dirt_block.tscn")
var grass = preload("res://grass_block.tscn")

# Create an empty 3D array to represent your world
var world_array = []

func _ready():
	generate_world()


# Initialize the world_array with default values (e.g., 0 for empty tiles)
func generate_world(seed=null):
	if seed == null: noise_generator.set_seed(randi_range(0, 1000))
	else: noise_generator.set_seed(seed)
	var current_noise = generatePerlinNoise(world_width, world_depth)
	for x in range(world_width):
		var column_2d = []
		for y in range(world_depth):
			var column_3d = []
			for z in range(world_depth):
				column_3d.append(0)  # You can use different values to represent different types of tiles in 3D
			column_2d.append(column_3d)
		world_array.append(column_2d)
	
	for x in range(0, world_width):
		var row = current_noise[x]
		for y in range(0, world_depth-1):
			var grass_y = row[y] * noise_scale + surface_height
			var dirt_y = grass_y-1
			set_tile(x, grass_y, y, 2)
			while dirt_y >= 0:
				set_tile(x, dirt_y, y, 1)
				dirt_y -= 1
	
	load_world()
	
	get_node("Player").position.y = surface_height + 5

# Access and modify elements in the 3D world array
func set_tile(x, y, z, value):
	world_array[x][y][z] = value

func get_tile(x, y, z):
	return world_array[x][y][z]

func load_world():
	for child in get_node("Blocks").get_children():
		child.queue_free()
	
	for x in range(world_width):
		for y in range(world_height):
			for z in range(world_depth):
				var tile = get_tile(x, y, z)
				
				var block
				if tile == 0: block = air.instantiate()
				elif tile == 1: block = dirt.instantiate()
				elif tile == 2: block = grass.instantiate()
				
				block.position.x = x
				block.position.y = y
				block.position.z = z
				get_node("Blocks").add_child(block)

func generatePerlinNoise(width, height):
	var noise_list = []
	
	for x in range(width):
		var row = []
		for y in range(height):
			var noise_value = noise_generator.get_noise_2d(x * noise_scale, y * noise_scale)
			row.append(noise_value)
		noise_list.append(row)
	
	return noise_list

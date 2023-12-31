extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var cap_mouse = false
var starting = true
var is_menu = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var look_dir:Vector2
@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
var camera_sense = 40
var selected_item = 0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if cap_mouse:
		_rotate_camera(delta)
	
	if Input.is_action_just_pressed("pause"):
		alter_paused()
		
	
	if $CanvasLayer/PauseMenu.is_save_press:
		print("saving")
		get_parent().save_file("user://saves/" + $CanvasLayer/PauseMenu/Save/LineEdit.text)
		$CanvasLayer/PauseMenu.is_save_press = false
	
	if $CanvasLayer/PauseMenu.is_resume_press:
		alter_paused()
		$CanvasLayer/PauseMenu.is_resume_press = false
	
	if Input.is_action_pressed("zoom") and cap_mouse:
		camera.fov = move_toward(camera.fov, 20, 10)
		camera_sense = 10
	else:
		camera.fov = move_toward(camera.fov, 70, 10)
		camera_sense = 40
	
	var collider: Node
	
	if Input.is_action_just_pressed("attack") and cap_mouse:
		if raycast.is_colliding():
			collider = raycast.get_collider()
			get_parent().world_array[collider.position.x][collider.position.y][collider.position.z] = 0
			collider.queue_free()
	
	if Input.is_action_just_pressed("place") and cap_mouse:
		match selected_item:
			0:
				if raycast.is_colliding():
					collider = raycast.get_collider()
					var place_vector = Vector3(collider.position) + raycast.get_collision_normal()
					get_parent().world_array[place_vector[0]][place_vector[1]][place_vector[2]] = 2
					var grass = get_parent().grass.instantiate()
					get_parent().add_child(grass)
					grass.position = place_vector
			1:
				if raycast.is_colliding():
					collider = raycast.get_collider()
					var place_vector = Vector3(collider.position) + raycast.get_collision_normal()
					get_parent().world_array[place_vector[0]][place_vector[1]][place_vector[2]] = 1
					var dirt = get_parent().dirt.instantiate()
					get_parent().add_child(dirt)
					dirt.position = place_vector
	
	if raycast.get_collider():
		raycast.get_collider().selected = true
		collider = raycast.get_collider()
	
	if cap_mouse:
		move_and_slide()
		$CanvasLayer/UI.x = snapped(position.x, 0.01)
		$CanvasLayer/UI.y = snapped(position.y, 0.01)
		$CanvasLayer/UI.z = snapped(position.z, 0.01)
		if collider:
			$CanvasLayer/UI.block_x = snapped(collider.position.x, 0.1)
			$CanvasLayer/UI.block_y = snapped(collider.position.y, 0.1)
			$CanvasLayer/UI.block_z = snapped(collider.position.z, 0.1)

func _input(event: InputEvent):
	if event is InputEventMouseMotion: look_dir = event.relative * 0.01

func _rotate_camera(delta: float, sense_mod: float = 1.0):
	#var input = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	var input = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	look_dir += input
	rotation.y -= look_dir.x * camera_sense * delta
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sense * sense_mod * delta, -1.5, 1.5)
	look_dir = Vector2.ZERO

func alter_paused():
	cap_mouse = !cap_mouse
	
	if cap_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if is_menu:
		$CanvasLayer/PauseMenu.visible = !$CanvasLayer/PauseMenu.visible
		$CanvasLayer/PauseMenu/Save/LineEdit.text = get_parent().world_file
	else: is_menu = true

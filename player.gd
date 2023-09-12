extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var cap_mouse = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var look_dir:Vector2
@onready var camera = $Camera3D
var camera_sense = 40


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
		cap_mouse = !cap_mouse
		
		if cap_mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("ads"):
		camera.fov = move_toward(camera.fov, 20, 5)
		camera_sense = 10
	else:
		camera.fov = move_toward(camera.fov, 70, 5)
		camera_sense = 40
	
	if cap_mouse:
		move_and_slide()

func _input(event: InputEvent):
	if event is InputEventMouseMotion: look_dir = event.relative * 0.01

func _rotate_camera(delta: float, sense_mod: float = 1.0):
	#var input = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	var input = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	look_dir += input
	rotation.y -= look_dir.x * camera_sense * delta
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sense * sense_mod * delta, -1.5, 1.5)
	look_dir = Vector2.ZERO
	
	

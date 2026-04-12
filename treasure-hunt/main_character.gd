extends CharacterBody3D

const WALK_SPEED = 5.0
const SPRINT_SPEED = 9.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVTY = 0.01

var speed 

# head bob
const BOB_FREQUENCY = 2
const  BOB_AMPLITUDE = 0.05
var bob_progress = 0.0

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * MOUSE_SENSITIVTY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVTY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed(("sprint")):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction : Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			# adds a small amount of inertia when controles are released 
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 10)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 10)
	else:
		# adds a amount of inertia when in air
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 4)
		velocity.y= lerp(velocity.y, direction.y * speed, delta * 4)
	
	# camera head bob 
	bob_progress += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(bob_progress)

	move_and_slide()
	
	# lets you see your mouse when escape is pressed and recaptures 
	# the mouse when you left click
	if Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("main input"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENCY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENCY / 2) * BOB_AMPLITUDE
	return pos

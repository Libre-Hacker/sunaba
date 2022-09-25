extends KinematicBody

export var jump_strength := 10.0

var can_move = true
var gravity = 25.0
var speed = 3.5
var jump_speed = 1.25
var mouse_sensitivity = 0.08
var _snap_vector = Vector3.DOWN

var velocity = Vector3()

onready var head = $Head as Spatial
onready var myoko = $Myoko
onready var camera = $Head/Camera as Camera

func _ready():
	#if is_network_master():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true
	myoko.visible = false


func get_input():
	var input_dir = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += global_transform.basis.x
	
	input_dir = input_dir.normalized()
	return input_dir

func _input(event):
	if !can_move:
		return
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		if can_move:
			can_move = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			can_move = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if !can_move:
		return
	velocity.y -= gravity * delta
	
	var desired_velocity = get_input() * speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	
	var just_landed = is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	if is_jumping:
		velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
	
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if Input.is_key_pressed(KEY_ESCAPE) && Input.is_key_pressed(KEY_TAB):
		get_tree().quit()

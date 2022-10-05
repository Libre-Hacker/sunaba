extends KinematicBody

export var camera_mode = 1
export var speed = 3.5
export var jump_strength := 10.0
export var gravity := 25.0

var _velocity = Vector3.ZERO
var _snap_vector = Vector3.DOWN
var motion = Vector3.ZERO

var mouse_sensitivity = 0.08

var puppet_pos = Vector3()
var puppet_vel = Vector3()
var puppet_rot = Vector3()

onready var spring_arm = $SpringArm
onready var head = $Head
onready var fp_camera = null
onready var tp_camera = $SpringArm/TPCamera
onready var _model := $Skin as Spatial
onready var parent = get_parent()
onready var ntr = $NetworkTickRate
onready var movetween = $MovementTween

func _ready():
	#fp_camera.current = false
	global_transform.origin = Vector3(0, 5, 0)
	if !is_network_master():
		#fp_camera.current = false
		#tp_camera.current = false
		pass#return
	#if is_network_master():
		#if camera_mode == 1:
			#fp_camera.current = false
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			#_model.visible = !is_network_master()
		#elif camera_mode == 3:
	tp_camera.current = is_network_master()
	_model.visible = true

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

func _physics_process(delta: float) -> void:
	if is_network_master():
		if camera_mode == 3 && !get_parent().player_paused:
			var move_direction := Vector3.ZERO
			move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
			move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
			
			
			_velocity.x = move_direction.x * speed
			_velocity.z = move_direction.z * speed
			_velocity.y -= gravity * delta
			
			var just_landed = is_on_floor() and _snap_vector == Vector3.ZERO
			var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
			if is_jumping:
				_velocity.y = jump_strength
				_snap_vector = Vector3.ZERO
			elif just_landed:
				_snap_vector = Vector3.DOWN
		elif camera_mode == 1:
			if get_parent().player_paused:
				if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				return
			else:
				if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			_velocity.y -= gravity * delta
			
			
			var desired_velocity = get_input() * speed
			_velocity.x = desired_velocity.x
			_velocity.z = desired_velocity.z
			
			var just_landed = is_on_floor() and _snap_vector == Vector3.ZERO
			var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
			if is_jumping:
				_velocity.y = jump_strength
				_snap_vector = Vector3.ZERO
			elif just_landed:
				_snap_vector = Vector3.DOWN
	else:
		global_transform.origin = puppet_pos
		_velocity.x = puppet_vel.x
		_velocity.z = puppet_vel.z
		rotation.y = puppet_rot.y
	if !movetween.is_active():
		_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle()
	if !is_network_master():
		if !movetween.is_active():
			_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	
func _process(_delta: float) -> void:
	if is_network_master() && camera_mode == 3:
		spring_arm.translation = translation
		spring_arm.translation.y = translation.y + 0.7

puppet func update_state(p_pos, p_vel, p_rot):
	puppet_pos = p_pos
	puppet_vel = p_vel
	puppet_rot = p_rot
	
	movetween.interpolate_property(self, "global_transform", global_transform, Transform(global_transform.basis, puppet_pos), 0.1)
	movetween.start()

func _input(event):
	if !is_network_master() or !camera_mode == 1 or get_parent().player_paused:
		return
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))


func _on_timeout():
	pass
	if is_network_master():
		#rpc_unreliable("update_state")
		#rset_unreliable(puppet_pos, global_transform)
		#rset_unreliable(puppet_vel, _velocity)
		#rset_unreliable(puppet_rot, Vector3(rotation.x, rotation.y, rotation.z))
		
		
		rpc_unreliable("update_state", global_transform.origin, _velocity, Vector2(rotation.x, rotation.y))

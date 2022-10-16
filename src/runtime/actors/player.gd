extends KinematicBody

export var camera_mode = 3
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

var current_handprop = null
var handprop1 = preload("res://src/runtime/handprops/hello_world.tres")
var handprop2 = preload("res://src/runtime/handprops/ball_stick.tres")
var handprop3 = null
var handprop4 = null
var handprop5 = null
var item

onready var spring_arm = $SpringArm
onready var tp_camera = $SpringArm/Camera
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
		$Control/Panel.hide()
		$Control/HBoxContainer.hide()
	#if is_network_master():
		#if camera_mode == 1:
			#fp_camera.current = false
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			#_model.visible = !is_network_master()
		#elif camera_mode == 3:
		if GameManager.use_touch_controls:
			$"Control/MobileControls/Virtual joystick".show()
			$Control/MobileControls/JumpButton.show()
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
		if !get_parent().player_paused:
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
			
			if Input.is_key_pressed(KEY_1) and !handprop1 == null and !current_handprop == handprop1:
				if _model.has_node("handprop"):
					_model.get_node("handprop").queue_free()
				current_handprop = handprop1
				item = handprop1.scene.instance()
				item.name == "handprop"
				_model.add_child(item)
				item.translation = Vector3(0.238, 0.747, 0.448)
			if Input.is_key_pressed(KEY_2) and !handprop2 == null and !current_handprop == handprop2:
				if _model.has_node("handprop"):
					_model.get_node("handprop").queue_free()
				current_handprop = handprop2
				item = handprop2.scene.instance()
				item.name == "handprop"
				_model.add_child(item)
				item.translation = Vector3(0.238, 0.747, 0.448)
			
			
			
			if Input.is_key_pressed(KEY_P):
				#handprop1 = load("res://src/runtime/handprops/hello_world.tres")
				print(var2str(handprop1))
			
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


func _on_timeout():
	pass
	if is_network_master():
		#rpc_unreliable("update_state")
		#rset_unreliable(puppet_pos, global_transform)
		#rset_unreliable(puppet_vel, _velocity)
		#rset_unreliable(puppet_rot, Vector3(rotation.x, rotation.y, rotation.z))
		
		
		rpc_unreliable("update_state", global_transform.origin, _velocity, Vector2(rotation.x, rotation.y))


func jump():
	Input.action_press("jump")

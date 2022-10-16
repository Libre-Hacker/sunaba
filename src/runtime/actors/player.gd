extends KinematicBody


export var jump_strength := 10.0

var can_move = true
var gravity = 25.0
var speed = 3.5
var jump_speed = 1.25
var mouse_sensitivity = 0.08
var _snap_vector = Vector3.DOWN

var velocity = Vector3()

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

onready var head = $Head as Spatial
onready var camera = $Head/Camera as Camera
onready var _model := $Skin as Spatial
onready var parent = get_parent()
onready var ntr = $NetworkTickRate
onready var movetween = $MovementTween
onready var item_attachment = $Skin/metarig/Skeleton/ItemAttachment

func _ready():
	global_transform.origin = Vector3(0, 5, 0)
	if !is_network_master():
		$Control/Panel.hide()
		$Control/HBoxContainer.hide()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = is_network_master()
	if is_network_master():
		_model.hide_meshes()
	else:
		_model.show_meshes

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

func _physics_process(delta: float) -> void:
	if is_network_master():
		if !get_parent().player_paused:
			if Input.is_key_pressed(KEY_TAB):
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
		
		if Input.is_key_pressed(KEY_ESCAPE) && Input.is_key_pressed(KEY_TAB):
			get_tree().quit()
		
		if Input.is_key_pressed(KEY_1) and !handprop1 == null and !current_handprop == handprop1:
			if _model.has_node("handprop"):
				_model.get_node("handprop").queue_free()
			current_handprop = handprop1
			item = handprop1.scene.instance()
			item.name == "handprop"
			item_attachment.add_child(item)
		if Input.is_key_pressed(KEY_2) and !handprop2 == null and !current_handprop == handprop2:
			if _model.has_node("handprop"):
				_model.get_node("handprop").queue_free()
			current_handprop = handprop2
			item = handprop2.scene.instance()
			item.name == "handprop"
			item_attachment.add_child(item)
			
			
			
		if Input.is_key_pressed(KEY_P):
			#handprop1 = load("res://src/runtime/handprops/hello_world.tres")
			print(var2str(handprop1))
			
	else:
		global_transform.origin = puppet_pos
		velocity.x = puppet_vel.x
		velocity.z = puppet_vel.z
		rotation.y = puppet_rot.y
	if !movetween.is_active():
		velocity = move_and_slide(velocity, Vector3.UP, true)
	if !is_network_master():
		if !movetween.is_active():
			velocity = move_and_slide(velocity, Vector3.UP, true)

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
		
		pass
		#rpc_unreliable("update_state", global_transform.origin, _velocity, Vector2(rotation.x, rotation.y))

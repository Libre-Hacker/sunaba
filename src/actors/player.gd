extends KinematicBody

export var max_speed : int = 12
export var acceleration : int = 60
export var friction : int = 50
export var air_friction : int = 10
export var jump_impulse : int = 20
export var gravity : int = -40

export var mouse_sensitivity : float = .1
export var controller_sensitivity : int = 3

var velocity = Vector3.ZERO
var snap_vector = Vector3.ZERO

var tool_to_spawn
var tool_to_drop

var puppet_pos = Vector3()
var puppet_vel = Vector3()
var puppet_rot = Vector3()

var reach = null
var aimcast = null
var damage = 100
var is_reloading : bool
var has_fired : bool = false
var weapon_type : String = ""
var muzzle = null

onready var head = $Head
onready var fp_camera = $Head/Camera
onready var tp_camera = $Head/SpringArm/SpringArm/TPCamera
onready var model = $Himiko
onready var ntr = $NetworkTickRate
onready var movetween = $MovementTween
onready var hand = $Head/Hand
onready var fp_reach = $Head/Camera/Reach
onready var tp_reach = $Head/SpringArm/SpringArm/TPCamera/Reach
onready var fp_aimcast = $Head/Camera/AimCast
onready var tp_aimcast = $Head/SpringArm/SpringArm/TPCamera/AimCast

# Hud Related Nodes
onready var crosshair = $Hud/Crosshair
onready var reload_label = $Hud/Crosshair/Label 
onready var tool_label = $Hud/ToolPanel/Label
onready var tool_ammo_bar = $Hud/ToolPanel/ProgressBar


onready var pb_gun_hr = preload("res://src/weapons/paintball_gun_hr.tscn")
onready var pb_gun = preload("res://src/entities/wp_pbgun.tscn")
onready var pb_pistol_hr = preload("res://src/weapons/paintball_pistol_hr.tscn")
onready var pb_pistol = preload("res://src/entities/wp_pistol.tscn")

onready var b_decal = preload("res://src/bullet_decal.tscn")

func _ready():
	if is_network_master():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fp_camera.current = is_network_master()
	tp_camera.current = false
	model.visible = !is_network_master()
	reach = fp_reach
	aimcast = fp_aimcast
	reload_label.hide()
	$Hud/ToolPanel.hide()

func _input(event):
	if !is_network_master():
		return
	
	#if event.is_action_pressed("action_button") && get_parent().mouse_over_ui == false: 
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	if event.is_action_pressed("pause"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: 
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			crosshair.hide()
		else: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			crosshair.show()
	
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))

func _physics_process(delta):
	if is_network_master():
		var input_vector = get_input_vector()
		var direction = get_direction(input_vector)
		apply_movement(direction, delta)
		apply_gravity(delta)
		apply_friction(direction, delta)
		jump()
		apply_controller_rotation()
		head.rotation.x = clamp(head.rotation.x, deg2rad(-75), deg2rad(75))
	else:
		global_transform.origin = puppet_pos
		velocity.x = puppet_vel.x
		velocity.z = puppet_vel.z
		rotation.y = puppet_rot.y
	if !movetween.is_active():
		velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true, 4, .7853)
	
	#for idx in get_slide_count():
		#var collision = get_slide_collision(idx)

func _process(_delta): 
	$Hud/Panel.theme = ThemeManager.theme
	$Hud/ToolPanel.theme = ThemeManager.theme
	crosshair.theme = ThemeManager.theme
	tool_ammo_bar.get_node("Label").text = var2str(round(tool_ammo_bar.value)) + " / " + var2str(round(tool_ammo_bar.max_value))
	
	if Input.is_action_just_pressed("camera_toggle"):
		if fp_camera.current == true:
			fp_camera.current = false
			tp_camera.current = is_network_master()
			model.visible = true
			reach = tp_reach
			aimcast = tp_aimcast
		elif tp_camera.current == true:
			fp_camera.current = is_network_master()
			tp_camera.current = false
			model.visible = !is_network_master()
			reach = fp_reach
			aimcast = fp_aimcast
	
	if reach.is_colliding():
		if "wp_pbgun" in reach.get_collider().get_name():
			tool_to_spawn = pb_gun_hr.instance()
		elif "wp_pistol" in reach.get_collider().get_name():
			tool_to_spawn = pb_pistol_hr.instance()
		else:
			tool_to_spawn = null
	else:
		tool_to_spawn = null
	
	if hand.get_child_count() > 0:
		if hand.get_child(0) != null:
			if hand.get_child(0).get_name() == "Paintball Gun":
				tool_to_drop = pb_gun.instance()
			elif hand.get_child(0).get_name() == "Paintball Pistol":
				tool_to_drop = pb_pistol.instance()
		else:
			tool_to_drop = null
	else:
		tool_to_drop = null
	
	if Input.is_action_just_pressed("interact"):
		if tool_to_spawn != null:
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					get_parent().add_child(tool_to_drop)
					tool_to_drop.global_transform = hand.global_transform
					tool_to_drop.dropped = true
					hand.get_child(0).queue_free()
			tool_ammo_bar.max_value = 100
			tool_ammo_bar.value = 100
			reach.get_collider().queue_free()
			hand.add_child(tool_to_spawn)
			tool_ammo_bar.value = tool_to_spawn.max_ammo
			tool_ammo_bar.max_value = tool_to_spawn.max_ammo
			damage = tool_to_spawn.damage
			weapon_type = tool_to_spawn.weapon_type
			tool_to_spawn.rotation = hand.rotation
			muzzle = tool_to_spawn.get_node("Muzzle")
			tool_label.text = tool_to_spawn.get_name()
			$Hud/ToolPanel.show()
	
	if weapon_type == "semi":
		if Input.is_action_just_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_fire()
		elif Input.is_action_just_released("action_button"):
			has_fired = false
	elif weapon_type == "auto":
		if Input.is_action_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_fire()
	
	if (Input.is_action_pressed("reload") and tool_ammo_bar.value < tool_ammo_bar.max_value ) or tool_ammo_bar.value == tool_ammo_bar.min_value:
		if is_reloading: return
		is_reloading = true
		$ReloadTimer.start()
		reload_label.show()

func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	return input_vector if input_vector.length() > 1 else input_vector

func get_direction(input_vector):
	var direction = Vector3.ZERO
	direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction

func apply_movement(direction, delta):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z

func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(direction * max_speed, air_friction * delta).x
			velocity.z = velocity.move_toward(direction * max_speed, air_friction * delta).z

func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jump_impulse)

func update_snap_vector():
	snap_vector = get_floor_normal() if is_on_floor() else Vector3.DOWN

func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap_vector = Vector3.ZERO
		velocity.y = jump_impulse
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse / 2:
		velocity.y = jump_impulse / 2

func apply_controller_rotation():
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	if InputEventJoypadMotion:
		rotate_y(deg2rad(-axis_vector.x * controller_sensitivity))
		head.rotate_x(deg2rad(-axis_vector.y * controller_sensitivity))


puppet func update_state(p_pos, p_vel, p_rot):
	puppet_pos = p_pos
	puppet_vel = p_vel
	puppet_rot = p_rot
	
	movetween.interpolate_property(self, "global_transform", global_transform, Transform(global_transform.basis, puppet_pos), 0.1)
	movetween.start()


func _on_timeout():
	if is_network_master():
		rpc_unreliable("update_state", global_transform.origin, velocity, Vector2(rotation.x, rotation.y))

func _fire():
	tool_ammo_bar.value -= 1
	if tool_ammo_bar.value != 0:
		$WeaponSound.play()
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("bot"):
				print("hit bot")
				target.health -= damage
			else:
				var b = b_decal.instance()
				target.add_child(b)
				b.global_transform.origin = aimcast.get_collision_point()
				b.look_at(aimcast.get_collision_point() + aimcast.get_collision_normal(), Vector3.UP)
	has_fired = true
	if weapon_type == "auto":
		$FireTimer.start()

func _on_reload_timer_timeout():
	$ReloadTimer.stop()
	tool_ammo_bar.value = tool_ammo_bar.max_value
	reload_label.hide()
	is_reloading = false
	


func _on_fire_timer_timeout():
	if weapon_type == "auto":
		has_fired = false

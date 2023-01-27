extends CharacterBody3D

@export var default_speed : int = 5
@export var sprint_speed : int = 10
@export var acceleration : int = 60
@export var friction : int = 50
@export var air_friction : int = 10
@export var jump_impulse : int = 20
@export var gravity : int = -40
@export var default_walk_sound_time : float = 0.35
@export var sprint_walk_sound_time : float = 0.24

@export var mouse_sensitivity : float = 1
@export var controller_sensitivity : int = 20


var snap_vector = Vector3.ZERO

var tool_to_spawn
var tool_to_drop

var max_speed = default_speed
var health = 100
var reach = null
var aimcast = null
var ammo = 25
var max_ammo = 25
var damage = 100
var is_reloading : bool
var has_fired : bool = false
var weapon_type : String = ""
var muzzle = null
var can_play_walk_sound : bool = true
var times_jumped = 0
const SWAY = 30
const VSWAY = 45
var view_mode : bool = false

@onready var head = $Head
@onready var fp_camera = $Head/Camera3D
@onready var tp_camera = $Head/SpringArm3D/SpringArm3D/TPCamera
@onready var model = $Himiko
@onready var arms_model = $Head/arms
@onready var animation_player = $Himiko/AnimationPlayer
@onready var ntr = $NetworkTickRate
@onready var hand_loc = $Head/HandLoc
@onready var hand = $Head/Hand
@onready var fp_reach = $Head/Camera3D/Reach
@onready var tp_reach = $Head/SpringArm3D/SpringArm3D/TPCamera/Reach
@onready var fp_aimcast = $Head/Camera3D/AimCast
@onready var tp_aimcast = $Head/SpringArm3D/SpringArm3D/TPCamera/AimCast
@onready var walk_timer = $WalkTimer

# Hud Related Nodes
@onready var crosshair = $Hud/Crosshair
@onready var reload_label = $Hud/Crosshair/Label 
@onready var tool_label = $Hud/ToolPanel/Label
@onready var tool_ammo_bar = $Hud/ToolPanel/ProgressBar
@onready var health_bar = $Hud/Panel/HealthBar
@onready var health_counter = $Hud/Panel/HealthBar/Label 


#@onready var pb_gun_hr = preload("res://weapons/paintball_gun_hr.tscn")
#@onready var pb_gun = preload("res://entities/wp_pbgun.tscn")
#@onready var pb_pistol_hr = preload("res://weapons/paintball_pistol_hr.tscn")
#@onready var pb_pistol = preload("res://entities/wp_pistol.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	reach = fp_reach
	aimcast = fp_aimcast
	fp_camera.current = true
	tp_camera.current = false
	model.visible = false
	#arms_model.visible = is_multiplayer_authority()
	
	reload_label.hide()
	$Hud/ToolPanel.hide()
	max_speed = default_speed
	hand.top_level = true

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		return
	
	#if event.is_action_pressed("action_button") && get_parent().mouse_over_ui == false: 
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	if event.is_action_pressed("pause"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: 
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			crosshair.hide()
			Global.game_paused = true
		else: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			crosshair.show()
			Global.game_paused = false
	
	if Input.is_action_just_pressed("view") and tp_camera.current == true:
		if !view_mode:
			view_mode = true
		else:
			view_mode = false
			head.global_rotation = Vector3.ZERO
	
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_axis : Vector2 = event.relative if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Vector2.ZERO
		rotation.y -= mouse_axis.x * mouse_sensitivity * .001
		head.rotation.x = clamp(head.rotation.x - mouse_axis.y * mouse_sensitivity * .001, -1.5, 1.5)
			
	
	if Input.is_action_just_pressed("camera_toggle"):
		if fp_camera.current == true:
			fp_camera.current = false
			tp_camera.current = is_multiplayer_authority()
			model.visible = true
			arms_model.visible = false
			reach = tp_reach
			aimcast = tp_aimcast
		elif tp_camera.current == true:
			fp_camera.current = is_multiplayer_authority()
			tp_camera.current = false
			model.visible = !is_multiplayer_authority()
			#arms_model.visible = is_multiplayer_authority()
			reach = fp_reach
			aimcast = fp_aimcast
	
	if Input.is_action_just_pressed("interact"):
		if tool_to_spawn != null:
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					get_parent().add_child(tool_to_drop)
					tool_to_drop.global_transform = hand.global_transform
					tool_to_drop.dropped = true
					hand.get_child(0).queue_free()
			tool_label.text = tool_to_spawn.get_name()
			reach.get_collider().queue_free()
			hand.add_child(tool_to_spawn)
			ammo = tool_to_spawn.max_ammo
			max_ammo = tool_to_spawn.max_ammo
			$FireTimer.wait_time = tool_to_spawn.cooldown_time
			damage = tool_to_spawn.damage
			weapon_type = tool_to_spawn.weapon_type
			tool_to_spawn.rotation = hand_loc.rotation
			muzzle = tool_to_spawn.get_node("Muzzle")
			$Hud/ToolPanel.show()
			$PickupSound.play()
	
	
	if Input.is_action_just_pressed("sprint"):
		$SprintSound.play()
	
	if (Input.is_action_just_pressed("reload") and ammo < max_ammo ) or ammo == 0:
		if is_reloading: return
		is_reloading = true
		$ReloadSound.play()
		$ReloadTimer.start()
		reload_label.show()
	
	

func _physics_process(delta):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		return
	
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(direction, delta)
	apply_gravity(delta)
	apply_friction(direction, delta)
	jump()
	apply_controller_rotation()
	set_velocity(velocity)
	# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `snap_vector`
	set_up_direction(Vector3.UP)
	set_floor_stop_on_slope_enabled(true)
	set_max_slides(4)
	set_floor_max_angle(.7853)
	move_and_slide()
	velocity = velocity
	
	if is_on_floor():
		times_jumped = 0
	
	if velocity.length() == 0:
		animation_player.play("Idle")
	else:
		if max_speed == default_speed and is_on_floor():
			animation_player.play("Walk")
			if can_play_walk_sound:
				can_play_walk_sound = false
				$WalkSound.play()
				walk_timer.start()
		elif is_on_floor():
			animation_player.play("Run")
			if can_play_walk_sound:
				can_play_walk_sound = false
				$RunSound.play()
				walk_timer.start()
		elif !is_on_floor():
			animation_player.play("Fall")
		
	
	hand.global_transform.origin = hand_loc.global_transform.origin
	hand.rotation.y = lerp_angle(hand.rotation.y, rotation.y, SWAY * delta)
	hand.rotation.x = lerp_angle(hand.rotation.x, head.rotation.x, VSWAY * delta)
	
	if !Global.game_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		crosshair.show()
	
	$Hud/Panel/HealthBar.value = health
	if health == 0:
		die()
	
	$Hud/Panel.theme = ThemeManager.theme
	$Hud/ToolPanel.theme = ThemeManager.theme
	crosshair.theme = ThemeManager.theme
	tool_ammo_bar.get_node("Label").text = var_to_str(ammo) + " / " + var_to_str(max_ammo)
	tool_ammo_bar.value = ammo
	tool_ammo_bar.max_value = max_ammo
	health_bar.value = health
	health_counter.text = var_to_str(health)
	if is_on_floor():
		max_speed = default_speed
		walk_timer.wait_time = default_walk_sound_time
	else:
		max_speed += 0.1
	$Hud/Panel/SprintingIcon.hide()
	
	
	
	
	if reach.is_colliding():
		if "wp" in reach.get_collider().get_name():
			tool_to_spawn = reach.get_collider().get_weapon().instantiate()
		else:
			tool_to_spawn = null
	else:
		tool_to_spawn = null
	
	if hand.get_child_count() > 0:
		if hand.get_child(0) != null:
			#if hand.get_child(0).get_name() == "Paintball Gun":
				#tool_to_drop = pb_gun.instantiate()
			#elif hand.get_child(0).get_name() == "Paintball Pistol":
				#tool_to_drop = pb_pistol.instantiate()
			tool_to_drop = hand.get_child(0).get_weapon().instantiate()
		else:
			tool_to_drop = null
	else:
		tool_to_drop = null
	
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
	
	if Input.is_action_pressed("sprint"): #and is_on_floor():
		max_speed = sprint_speed
		walk_timer.wait_time = sprint_walk_sound_time
		$Hud/Panel/SprintingIcon.show()
	elif Input.is_action_pressed("sprint") and !is_on_floor():
		max_speed += 1
		walk_timer.wait_time = sprint_walk_sound_time
		$Hud/Panel/SprintingIcon.show()

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
	if (Input.is_action_just_pressed("jump") and is_on_floor()) or (Input.is_action_just_pressed("jump") and times_jumped == 1): #or (Input.is_action_just_pressed("jump") and is_on_wall()):
		snap_vector = Vector3.ZERO
		velocity.y = jump_impulse
		times_jumped += 1
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse / 2.0:
		velocity.y = jump_impulse / 2.0

func apply_controller_rotation():
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	if InputEventJoypadMotion:
		rotation.y -= axis_vector.x * controller_sensitivity * .001
		head.rotation.x = clamp(head.rotation.x - axis_vector.y * controller_sensitivity * .001, -1.5, 1.5)


func die():
	get_parent().prep_for_respawn()
	queue_free()


func _fire():
	if !is_reloading and ammo != 0:
		ammo -= 1
		hand.get_child(0).get_node("WeaponSound").play()
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("bot"):
				print("hit bot")
				target.health -= damage
			else:
				var b_decal = hand.get_child(0).get_bullet_hole()
				var b = b_decal.instantiate()
				target.add_child(b)
				b.global_transform.origin = aimcast.get_collision_point()
				#b.look_at(aimcast.get_collision_point() + aimcast.get_collision_normal())
	has_fired = true
	if weapon_type == "auto":
		$FireTimer.start()

func _on_reload_timer_timeout():
	$ReloadTimer.stop()
	ammo = max_ammo
	reload_label.hide()
	is_reloading = false
	


func _on_fire_timer_timeout():
	if weapon_type == "auto":
		has_fired = false

func add_tool(tool_name : String):
	if tool_name == "pbgun":
		pass#tool_to_spawn = pb_gun_hr.instantiate()
	elif tool_name == "pistol":
		pass#tool_to_spawn = pb_pistol_hr.instantiate()
	else:
		tool_to_spawn = null
		return
	if hand.get_child_count() > 0:
		if hand.get_child(0) != null:
			if hand.get_child(0).get_name() == "Paintball Gun":
				pass#tool_to_drop = pb_gun.instantiate()
			elif hand.get_child(0).get_name() == "Paintball Pistol":
				pass#tool_to_drop = pb_pistol.instantiate()
		else:
			tool_to_drop = null
	else:
		tool_to_drop = null
	if hand.get_child_count() > 0:
		if hand.get_child(0) != null:
			get_parent().add_child(tool_to_drop)
			tool_to_drop.global_transform = hand.global_transform
			tool_to_drop.dropped = true
			hand.get_child(0).queue_free()
	tool_ammo_bar.max_value = 100
	tool_ammo_bar.value = 100
	hand.add_child(tool_to_spawn)
	tool_ammo_bar.value = tool_to_spawn.max_ammo
	tool_ammo_bar.max_value = tool_to_spawn.max_ammo
	damage = tool_to_spawn.damage
	weapon_type = tool_to_spawn.weapon_type
	tool_to_spawn.rotation = hand.rotation
	muzzle = tool_to_spawn.get_node("Muzzle")
	$Hud/ToolPanel.show()


func _on_walk_timer_timeout():
	can_play_walk_sound = true

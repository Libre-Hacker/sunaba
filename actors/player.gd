extends CharacterBody3D

@export var default_speed : int = 5
@export var sprint_speed : int = 10
@export var crouch_move_speed : int = 2
@export var crouch_speed : int = 20
@export var acceleration : int = 60
@export var friction : int = 50
@export var air_friction : int = 10
@export var jump_impulse : int = 20
@export var gravity : int = -40
@export var default_walk_sound_time : float = 0.35
@export var sprint_walk_sound_time : float = 0.24
@export var vel : Vector3 = velocity
@export var mouse_sensitivity : float = 1
@export var controller_sensitivity : int = 25

@export var foot_sounds : Array

var snap_vector = Vector3.ZERO

var current_tool : int
var tool1
var tool2
var tool3
var tool4
var tool_to_spawn
var tool_to_drop

var default_height = 1.497
var crouch_height = 0.8
var head_height = 1.111
var head_crouch_height = 0.866
var max_speed = default_speed
var health = 100
var reach = null
var aimcast = null
var ammo = 25
var max_ammo = 25
var damage = 100
var spread = 25
var is_reloading : bool
var has_fired : bool = false
var weapon_type : String = ""
var muzzle = null
var can_play_walk_sound : bool = true
var times_jumped = 0
const SWAY = 50
const VSWAY = 45
var view_mode : bool = false

var player_model : String

@onready var head = $Head
@onready var fp_camera = $Head/Camera3D
@onready var tp_camera = $Head/SpringArm3D/SpringArm3D/TPCamera
@onready var model = $PlayerModel
@onready var model1 = $Female
@onready var model2 = $Male
@onready var coll_shape = $CollisionShape3D
#@onready var arms_model = $Head/arms
@onready var animation_player = $PlayerModel/AnimationPlayer
@onready var animation_player1 = $Female/AnimationPlayer
@onready var animation_player2 = $Male/AnimationPlayer
@onready var gun_ap = $Head/AnimationPlayer
@onready var hand_loc = $Head/HandLoc
@onready var hand = $Head/Hand
@onready var fp_reach = $Head/Camera3D/Reach
@onready var tp_reach = $Head/SpringArm3D/SpringArm3D/TPCamera/Reach
@onready var fp_aimcast = $Head/Camera3D/AimCast
@onready var tp_aimcast = $Head/SpringArm3D/SpringArm3D/TPCamera/AimCast
@onready var fp_ray_container = $Head/Camera3D/RayContainer
@onready var walk_timer = $WalkTimer

# Hud Related Nodes
@onready var crosshair = $Hud/Crosshair
@onready var reload_label = $Hud/Crosshair/Label 
@onready var tool_label = $Hud/ToolPanel/Label
@onready var tool_ammo_bar = $Hud/ToolPanel/ProgressBar
@onready var health_bar = $Hud/Panel/HealthBar
@onready var health_counter = $Hud/Panel/HealthBar/Label 
@onready var sb_menu_window = $Hud/SBMenuWindow
@onready var sb_menu = $Hud/SBMenuWindow/SBMenu


#@onready var pb_gun_hr = preload("res://weapons/paintball_gun_hr.tscn")
#@onready var pb_gun = preload("res://entities/wp_pbgun.tscn")
#@onready var pb_pistol_hr = preload("res://weapons/paintball_pistol_hr.tscn")
#@onready var pb_pistol = preload("res://entities/wp_pistol.tscn")

#Compoments
@onready var tool_system = $Compoments/ToolSystem

func _enter_tree(): if Global.is_networked_game: set_multiplayer_authority(str(name).to_int())

func _ready():
	if is_multiplayer_authority() or !Global.is_networked_game:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		reach = fp_reach
		aimcast = fp_aimcast
		if str(name) == var_to_str(multiplayer.get_unique_id()):
			$Hud/Panel/Label.text = "Player " + str(name)
		$Hud/Crosshair.show()
		$Hud/Panel.show()
		$Hud/ToolPanel.show()
		#Console.register_env("player", self)
	fp_camera.current = is_multiplayer_authority()
	tp_camera.current = false
	model.visible = !is_multiplayer_authority()
	model1.visible = !is_multiplayer_authority()
	model2.visible = !is_multiplayer_authority()
	#arms_model.visible = is_multiplayer_authority()
	get_parent().get_node("OutOfBounds").connect("body_entered", Callable(self, "out_of_bounds"))
	
	reload_label.hide()
	$Hud/ToolPanel.hide()
	max_speed = default_speed
	#hand.top_level = true

func _input(event):
	if !is_multiplayer_authority() and Global.is_networked_game:
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
	
	
	if (event is InputEventMouseMotion) and (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		if !view_mode:
			var mouse_axis : Vector2 = event.relative if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Vector2.ZERO
			rotation.y -= mouse_axis.x * mouse_sensitivity * .001
			head.rotation.x = clamp(head.rotation.x - mouse_axis.y * mouse_sensitivity * .001, -1.5, 1.5)
		else :
			var mouse_axis : Vector2 = event.relative if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Vector2.ZERO
			head.rotation.y -= mouse_axis.x * mouse_sensitivity * .001
			head.rotation.x = clamp(head.rotation.x - mouse_axis.y * mouse_sensitivity * .001, -1.5, 1.5)
			
	
	if Input.is_action_just_pressed("camera_toggle"):
		if fp_camera.current == true:
			fp_camera.current = false
			tp_camera.current = true
			#arms_model.visibtle = false
			reach = tp_reach
			aimcast = tp_aimcast
		elif tp_camera.current == true:
			fp_camera.current = true
			tp_camera.current = false
			#arms_model.visible = is_multiplayer_authority()
			reach = fp_reach
			aimcast = fp_aimcast
	
	if Input.is_action_just_pressed("interact"):
		if tool_to_spawn != null:
			add_tool(tool_to_spawn)
			tool_to_spawn = null
			reach.get_collider().queue_free()
			#if hand.get_child_count() > 0:
				#if hand.get_child(0) != null:
					#equip(tool_to_spawn, tool_to_drop)
					#rpc("equip", tool_to_spawn, tool_to_drop)
			#else:
				#equip(tool_to_spawn)
				#rpc("equip", tool_to_spawn)
	if Input.is_action_just_pressed("hands"):
		if hand.get_child_count() > 0:
			if hand.get_child(0) != null:
				hand.get_child(0).queue_free()
				if is_multiplayer_authority() or !Global.is_networked_game:
					$Hud/ToolPanel.hide()
				$PickupSound.play()
				ammo = 1
				max_ammo = 1
				damage = 0
				weapon_type = ""
				current_tool = 0
	elif Input.is_action_just_pressed("tool1") and tool1 != null:
		equip(tool1)
		rpc("equip", tool1)
		current_tool = 1
	elif Input.is_action_just_pressed("tool2") and tool2 != null:
		equip(tool2)
		rpc("equip", tool2)
		current_tool = 2
	elif Input.is_action_just_pressed("tool3") and tool3 != null:
		equip(tool3)
		rpc("equip", tool3)
		current_tool = 3
	elif Input.is_action_just_pressed("tool4") and tool4 != null:
		equip(tool4)
		rpc("equip", tool4)
		current_tool = 4
	
	if Input.is_action_just_pressed("last_tool") and current_tool != 0:
		current_tool - 1
		if current_tool == 0:
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					hand.get_child(0).queue_free()
					if is_multiplayer_authority() or !Global.is_networked_game:
						$Hud/ToolPanel.hide()
					$PickupSound.play()
					ammo = 1
					max_ammo = 1
					damage = 0
					weapon_type = ""
		elif current_tool == 1 and tool1 != null:
			equip(tool1)
			rpc("equip", tool1)
		elif current_tool == 2 and tool2 != null:
			equip(tool2)
			rpc("equip", tool2)
		elif current_tool == 3 and tool3 != null:
			equip(tool3)
			rpc("equip", tool3)
		elif current_tool == 4 and tool4 != null:
			equip(tool4)
			rpc("equip", tool4)
	if Input.is_action_just_pressed("next_tool") and current_tool != 4:
		current_tool + 1
		if current_tool == 0:
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					hand.get_child(0).queue_free()
					if is_multiplayer_authority() or !Global.is_networked_game:
						$Hud/ToolPanel.hide()
					$PickupSound.play()
					ammo = 1
					max_ammo = 1
					damage = 0
					weapon_type = ""
		elif current_tool == 1 and tool1 != null:
			equip(tool1)
			rpc("equip", tool1)
		elif current_tool == 2 and tool2 != null:
			equip(tool2)
			rpc("equip", tool2)
		elif current_tool == 3 and tool3 != null:
			equip(tool3)
			rpc("equip", tool3)
		elif current_tool == 4 and tool4 != null:
			equip(tool4)
			rpc("equip", tool4)
		
	
	
	if (Input.is_action_just_pressed("reload") and ammo < max_ammo ) or ammo == 0:
		if is_reloading: return
		is_reloading = true
		$ReloadSound.play()
		#$ReloadSound.rpc("play")
		$ReloadTimer.start()
		reload_label.show()
		gun_ap.play("reload")
		#gun_ap.rpc("play", "reload")
	
@rpc("any_peer")
func equip(t2, t1 = null):
	var ttd
	if t1 != null:
		ttd = load(t1).instantiate()
	var tts = load(t2).instantiate()
	if hand.get_child_count() > 0:
		if hand.get_child(0) != null:
			if t1 != null:
				get_parent().add_child(ttd)
				ttd.global_transform = hand_loc.global_transform
				ttd.dropped = true
			hand.get_child(0).queue_free()
	tool_label.text = tts.get_name()
	hand.add_child(tts)
	ammo = tts.maxAmmo
	max_ammo = tts.maxAmmo
	spread = tts.spread
	randomize()
	for r in fp_ray_container.get_children():
		r.target_position.x = randi_range(spread, -spread)
		r.target_position.y = randi_range(spread, -spread)
	$FireTimer.wait_time = tts.cooldownTime
	damage = tts.damage
	weapon_type = tts.toolType
	tts.rotation = hand_loc.rotation
	muzzle = tts.get_node("Muzzle")
	if is_multiplayer_authority() or !Global.is_networked_game:
		$Hud/ToolPanel.show()
	$PickupSound.play()

func _process(_delta):
	if is_multiplayer_authority() or !Global.is_networked_game:
		player_model = Global.player_model
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: 
			crosshair.show()
		else: 
			crosshair.hide()
	if tp_camera.current == true:
		if Global.player_model == "male":
			model.visible = false
			model1.visible = false
			model2.visible = true
		elif Global.player_model == "female":
			model.visible = false
			model1.visible = true
			model2.visible = false
		elif Global.player_model == "custom":
			model.visible = true
			model1.visible = false
			model2.visible = false
	elif fp_camera.current == true:
		if Global.player_model == "male":
			model.visible = false
			model1.visible = false
			model2.visible = !is_multiplayer_authority()
		elif Global.player_model == "female":
			model.visible = false
			model1.visible = !is_multiplayer_authority()
			model2.visible = false
		elif Global.player_model == "custom":
			model.visible = !is_multiplayer_authority()
			model1.visible = false
			model2.visible = false
		

func _physics_process(delta):
	if !view_mode:
		head.global_position = $Male/Akari/GeneralSkeleton/Head/HeadPos.global_position
		head.global_rotation.y = $Male/Akari/GeneralSkeleton/Head/HeadPos.global_rotation.y
		head.global_rotation.z = $Male/Akari/GeneralSkeleton/Head/HeadPos.global_rotation.z
	#$Male/Akari/GeneralSkeleton.get_bone_pose_rotation($Male/Akari/GeneralSkeleton.find_bone("Head")).x = head.global_rotation.x
	#$Female/Akari/GeneralSkeleton.get_bone_pose_rotation($Female/Akari/GeneralSkeleton.find_bone("Head")).x = head.global_rotation.x
	
	
	
	if is_multiplayer_authority() or !Global.is_networked_game:
		max_speed = default_speed
		walk_timer.wait_time = default_walk_sound_time
		var input_vector = get_input_vector()
		var direction = get_direction(input_vector)
		jump()
		
		$Hud/Panel/HealthBar.value = health
		$Hud/Panel.theme = ThemeManager.theme
		$Hud/ToolPanel.theme = ThemeManager.theme
		crosshair.theme = ThemeManager.theme
		sb_menu_window.theme = ThemeManager.theme
		tool_ammo_bar.get_node("Label").text = var_to_str(ammo) + " / " + var_to_str(max_ammo)
		tool_ammo_bar.value = ammo
		tool_ammo_bar.max_value = max_ammo
		
		$Hud/Panel/SprintingIcon.hide()
		
		if Input.is_action_pressed("sprint"): #and is_on_floor():
			max_speed = sprint_speed
			walk_timer.wait_time = sprint_walk_sound_time
			$Hud/Panel/SprintingIcon.show()
		
		if Input.is_action_pressed("crouch"):
			coll_shape.shape.height = crouch_height #-= crouch_speed * delta
			#head.position.y = head_crouch_height
			max_speed = crouch_move_speed
			walk_timer.wait_time = 0.8
			model.position.y = 0.175
			model1.position.y = 0.175
			model2.position.y = 0.175
		else:
			coll_shape.shape.height = default_height#crouch_speed * delta 
			#head.position.y = head_height
			model.position.y = 0
			model1.position.y = 0
			model2.position.y = 0
			$Female/Akari.position = Vector3.ZERO
			$Female/Akari.rotation = Vector3.ZERO
			$Male/Akari.position = Vector3.ZERO
			$Male/Akari.rotation = Vector3.ZERO
			$PlayerModel/Akari.position = Vector3.ZERO
			$PlayerModel/Akari.rotation = Vector3.ZERO
		
		#coll_shape.shape.height = clamp(coll_shape.shape.height, 0.8, 1.497)
		
		apply_movement(direction, delta)
		apply_gravity(delta)
		apply_friction(direction, delta)
		apply_controller_rotation()
		set_velocity(velocity)
		# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `snap_vector`
		set_up_direction(Vector3.UP)
		set_floor_stop_on_slope_enabled(true)
		set_max_slides(4)
		set_floor_max_angle(.7853)
		move_and_slide()
		velocity = velocity
		vel = velocity
	
	if is_on_floor():
		times_jumped = 0
	
	if ((velocity.length() == 0) or (vel.length() == 0)) and !Input.is_action_pressed("crouch"):
		animation_player.play("Locomotion-Library/idle1")
		animation_player1.play("Locomotion-Library/idle1")
		animation_player2.play("Locomotion-Library/idle1")
		model.position.y = 0
		model1.position.y = 0
		model2.position.y = 0
		$Female/Akari.position = Vector3.ZERO
		$Female/Akari.rotation = Vector3.ZERO
		$Male/Akari.position = Vector3.ZERO
		$Male/Akari.rotation = Vector3.ZERO
		$PlayerModel/Akari.position = Vector3.ZERO
		$PlayerModel/Akari.rotation = Vector3.ZERO
		#animation_player.rpc("play", "idle")
		if !is_reloading and !gun_ap.current_animation == "fire":
			gun_ap.play("idle")
			#gun_ap.rpc("play", "idle")
	elif ((velocity.length() == 0) or (vel.length() == 0)) and Input.is_action_pressed("crouch"):
		animation_player.play("crouch_library/crouch_idle")
		animation_player1.play("crouch_library/crouch_idle")
		animation_player2.play("crouch_library/crouch_idle")
		model.position.y = 0.175
		model1.position.y = 0.175
		model2.position.y = 0.175
		#animation_player.rpc("play", "idle")
		if !is_reloading and !gun_ap.current_animation == "fire":
			gun_ap.play("idle")
			#gun_ap.rpc("play", "idle")
	else:
		if max_speed == default_speed and is_on_floor():
			animation_player.play("Locomotion-Library/walk")
			animation_player1.play("Locomotion-Library/walk")
			animation_player2.play("Locomotion-Library/walk")
			model.position.y = 0
			model1.position.y = 0
			model2.position.y = 0
			$Female/Akari.position = Vector3.ZERO
			$Female/Akari.rotation = Vector3.ZERO
			$Male/Akari.position = Vector3.ZERO
			$Male/Akari.rotation = Vector3.ZERO
			$PlayerModel/Akari.position = Vector3.ZERO
			$PlayerModel/Akari.rotation = Vector3.ZERO
			#animation_player.rpc("play", "walk")
			if can_play_walk_sound:
				can_play_walk_sound = false
				$WalkSound.stream = foot_sounds.pick_random()
				$WalkSound.play()
				walk_timer.start()
			if !is_reloading and !gun_ap.current_animation == "fire":
				gun_ap.play("walk")
				#gun_ap.rpc("play", "walk")
		elif max_speed == crouch_move_speed and is_on_floor():
			animation_player.play("crouch_library/crouch_walk")
			animation_player1.play("crouch_library/crouch_walk")
			animation_player2.play("crouch_library/crouch_walk")
			model.position.y = 0.175
			model2.position.y = 0.175
			#animation_player.rpc("play", "walk")
			if can_play_walk_sound:
				can_play_walk_sound = false
				$WalkSound.stream = foot_sounds.pick_random()
				$WalkSound.play()
				walk_timer.start()
			if !is_reloading and !gun_ap.current_animation == "fire":
				gun_ap.play("walk")
				#gun_ap.rpc("play", "walk")
		elif max_speed == sprint_speed and is_on_floor():
			animation_player.play("Locomotion-Library/run")
			animation_player1.play("Locomotion-Library/run")
			animation_player2.play("Locomotion-Library/run")
			model.position.y = 0
			model1.position.y = 0
			model2.position.y = 0
			$Female/Akari.position = Vector3.ZERO
			$Female/Akari.rotation = Vector3.ZERO
			$Male/Akari.position = Vector3.ZERO
			$Male/Akari.rotation = Vector3.ZERO
			$PlayerModel/Akari.position = Vector3.ZERO
			$PlayerModel/Akari.rotation = Vector3.ZERO
			#animation_player.rpc("play", "walk")
			if can_play_walk_sound:
				can_play_walk_sound = false
				$WalkSound.stream = foot_sounds.pick_random()
				$WalkSound.play()
				walk_timer.start()
			if !is_reloading and !gun_ap.current_animation == "fire":
				gun_ap.play("run")
				#gun_ap.rpc("play", "walk")
		elif !is_on_floor():
			animation_player.play("Locomotion-Library/jump")
			animation_player1.play("Locomotion-Library/jump")
			animation_player2.play("Locomotion-Library/jump")
			model.position.y = 0
			model1.position.y = 0
			model2.position.y = 0
			$Female/Akari.position = Vector3.ZERO
			$Female/Akari.rotation = Vector3.ZERO
			$Male/Akari.position = Vector3.ZERO
			$Male/Akari.rotation = Vector3.ZERO
			$PlayerModel/Akari.position = Vector3.ZERO
			$PlayerModel/Akari.rotation = Vector3.ZERO
			#animation_player.rpc("play", "jump")
			if !is_reloading and !gun_ap.current_animation == "fire":
				gun_ap.play("idle")
				#gun_ap.rpc("play", "idle")
		
	
	hand.global_transform.origin = hand_loc.global_transform.origin
	hand.global_rotation = hand_loc.global_rotation
	#hand.rotation.y = lerp_angle(hand.rotation.y, rotation.y, SWAY * delta)
	#hand.rotation.x = lerp_angle(hand.rotation.x, head.rotation.x, VSWAY * delta)
	$ReloadSound.global_transform.origin = hand_loc.global_transform.origin
	$PickupSound.global_transform.origin = hand_loc.global_transform.origin
	
	if hand.get_child_count() > 0:
		if hand.get_child(0) != null:
			#if hand.get_child(0).get_name() == "Paintball Gun":
				#tool_to_drop = pb_gun.instantiate()
			#elif hand.get_child(0).get_name() == "Paintball Pistol":
				#tool_to_drop = pb_pistol.instantiate()
			tool_to_drop = hand.get_child(0).toolObjectPath
		else:
			tool_to_drop = null
	else:
		tool_to_drop = null
	
	if (!is_multiplayer_authority() and Global.is_networked_game) or Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		return
	
	if !Global.game_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		crosshair.show()
	
	
	
	
	
	
	if reach.is_colliding():
		if "wp" in reach.get_collider().get_name() or "tl" in reach.get_collider().get_name():
			tool_to_spawn = reach.get_collider().toolPath
		else:
			tool_to_spawn = null
	else:
		tool_to_spawn = null
	
	
	
	if weapon_type == "Semi":
		if Input.is_action_just_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_fire()
		elif Input.is_action_just_released("action_button"):
			has_fired = false
	elif weapon_type == "Auto":
		if Input.is_action_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_fire()
	elif weapon_type == "Shotgun":
		if Input.is_action_just_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_fire_shotgun()
	elif weapon_type == "Spray":
		if Input.is_action_pressed("action_button"):
			if hand.get_child_count() > 0:
				if hand.get_child(0) != null:
					if !has_fired:
							_spray()
	
	if Global.game_mode == "Sandbox":
		if Input.is_action_just_pressed("menu2") and !sb_menu_window.visible:
			sb_menu_window.popup_centered()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.is_action_just_pressed("menu2"):
			hide_sb_menu()
			

func hide_sb_menu():
	sb_menu_window.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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
		$JumpSound.play()
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
	if (str_to_var(name) == 1) or !Global.is_networked_game:
		drop()
	else: 
		drop()
		rpc_id(1, "drop")
	print("dead")

func drop():
	if hand.get_child_count() > 0:
		if hand.get_child(0) != null:
			var ttd = load(tool_to_drop).instantiate()
			get_parent().add_child(ttd)
			ttd.global_transform = hand_loc.global_transform
			ttd.dropped = true
			hand.get_child(0).queue_free()
	queue_free()

func _fire():
	if !is_reloading and ammo != 0:
		ammo -= 1
		hand.get_child(0).get_node("WeaponSound").play()
		gun_ap.stop()
		gun_ap.play("fire")
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("bot") and !hand.get_child(0).name == "SprayGun":
				print("hit bot")
				target.health -= damage
			elif target.is_in_group("player") and !hand.get_child(0).name == "SprayGun":
				#print("hit player")
				var id = target.name
				target.rpc_id(str_to_var(id), "take_damage", damage)
			else:
				var b_decal = hand.get_child(0).decalPath
				add_bullet_hole(b_decal, aimcast)
				rpc("add_bullet_hole", b_decal)
	has_fired = true
	if weapon_type == "Auto":
		$FireTimer.start()

func _fire_shotgun():
	if !is_reloading and ammo != 0:
		ammo -= 1
		hand.get_child(0).get_node("WeaponSound").play()
		gun_ap.stop()
		gun_ap.play("fire")
		for r in fp_ray_container.get_children():
			r.target_position.x = randi_range(spread, -spread)
			r.target_position.y = randi_range(spread, -spread)
		
			if r.is_colliding():
				var target = r.get_collider()
				if target.is_in_group("bot") and !hand.get_child(0).name == "SprayGun":
					print("hit bot")
					target.health -= damage
				elif target.is_in_group("player") and !hand.get_child(0).name == "SprayGun":
					#print("hit player")
					var id = target.name
					target.rpc_id(str_to_var(id), "take_damage", damage)
				else:
					var b_decal = hand.get_child(0).decalPath
					add_bullet_hole(b_decal, r)
					rpc("add_bullet_hole", b_decal)
	has_fired = true
	$FireTimer.start()

func _spray():
	if !is_reloading and ammo != 0:
		ammo -= 1
		hand.get_child(0).get_node("WeaponSound").play()
		if aimcast.is_colliding():
			var b_decal = hand.get_child(0).decalPath
			add_bullet_hole(b_decal, aimcast)
			rpc("add_bullet_hole", b_decal)
	has_fired = true
	if weapon_type == "auto":
		$FireTimer.start()

func out_of_bounds(_area):
	if global_position.y < -250:
		print("out of bounds")
		take_damage(100)

@rpc("any_peer")
func take_damage(dmg : int):
	health -= dmg
	health_bar.value = health
	health_counter.text = var_to_str(health)
	if health == 0:
		die()

@rpc("any_peer")
func add_bullet_hole(b_dec_path, ac):
	var target = ac.get_collider()
	var b_decal = load(b_dec_path)
	var b = b_decal.instantiate()
	target.add_child(b)
	b.global_transform.origin = ac.get_collision_point()
	#b.look_at(ac.get_collision_point() + ac.get_collision_normal())

func _on_reload_timer_timeout():
	$ReloadTimer.stop()
	ammo = max_ammo
	reload_label.hide()
	is_reloading = false
	


func _on_fire_timer_timeout():
	has_fired = false



func _on_walk_timer_timeout():
	can_play_walk_sound = true


func _on_tool_tree_item_activated():
	var tool_name = $Hud/SBMenuWindow/SBMenu/TabBar/TabContainer/Tools/Tree.get_selected().get_text(0)
	var tool = "res://tools/" + tool_name + ".tscn"
	hide_sb_menu()
	add_tool(tool)

func add_tool(tool):
	if tool1 == null:
		tool1 = tool
		print(tool1)
		equip(tool1)
		rpc("equip", tool1)
		current_tool = 1
	elif tool2 == null:
		tool2 = tool
		print(tool2)
		equip(tool2)
		rpc("equip", tool2)
		current_tool = 2
	elif tool3 == null:
		tool3 = tool
		print(tool3)
		equip(tool3)
		rpc("equip", tool3)
		current_tool = 3
	elif tool4 == null:
		tool4 = tool
		print(tool4)
		equip(tool4)
		rpc("equip", tool4)
		current_tool = 4
	else:
		return

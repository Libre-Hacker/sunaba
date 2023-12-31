extends CharacterBody3D

@export var gravity : int = -40
@export var jump_impulse : int = 20
@export var damage = 10

var health = 100

var SPEED = 3.0
var has_fired = false

@onready var navigation_agent = $NavigationAgent3D
@onready var aimcast = $Head/AimCast
@onready var animation_player = $Female/AnimationPlayer

var target = null


#var lua : LuaAPI
#var lua_thread : LuaThread


func _start():
	pass


# Called when the node enters the scene tree for the first time.
func speak(string):
	get_parent().get_parent().get_parent().chat("Bot", string)

func _process(_delta):
	$Label3D.text = name + "  " + var_to_str(health) + " / 100"
	$Label3D.font = ThemeManager.theme.default_font
	
	
	if $Head/Reach.is_colliding()and !has_fired:
		fire()
	
	
	
	if velocity.length() == 0:
		animation_player.play("Locomotion-Library/idle1")
	else:
		#if is_on_floor():
		animation_player.play("Locomotion-Library/walk")
		#elif !is_on_floor():
			#animation_player.play("Fall")
	
	if health <= 0:
		queue_free()

func update_target_location(target_location):
	navigation_agent.set_target_position(target_location)

func _physics_process(_delta):
	if !$Timer.is_stopped():
		return
	
	var current_location = global_transform.origin
	var next_location = navigation_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	look_at(next_location)
	
	navigation_agent.set_velocity(new_velocity)
	
	

func _on_timer_timeout():
	pass

func fire():
	target = $Head/AimCast.get_collider()
	if target.is_in_group("bot"):
		print("hit bot")
		target.health -= damage
	elif target.is_in_group("player"):
		#print("hit player")
		var id = target.name
		if multiplayer.get_unique_id() == str_to_var(id):
			target.take_damage(damage)
		else :
			target.rpc_id(str_to_var(id), "take_damage", damage)
	has_fired = true
	$FireTimer.start()

func _on_navigation_agent_3d_target_reached():
	print("in range")


func _on_fire_timer_timeout():
	has_fired = false


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	
	move_and_slide()

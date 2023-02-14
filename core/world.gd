extends Node3D

@export var game_start_window_path : NodePath

var map = null

var prop_num : int = 1
var prop_name : String

var can_rebuild = false

var mouse_over_ui = false

var map_manager_instance = null

@onready var map_manager = $NavigationRegion3D/MapManager
#@onready var tb_loader = $NavigationRegion3D/TBLoader
@onready var navregion = $NavigationRegion3D
@onready var main_node = get_parent()

var player = null
var spawnpoint : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	Console.register_env("world", self)
	#QodotDependencies.check_dependencies(http_request)

func _physics_process(_delta):
	if !Global.player == null:
		pass#get_tree().call_group("bot", "update_target_location", player.global_transform.origin)

func chat(_name, msg):
	main_node.chat(_name, msg)

func load_map_path(path):
		var mappath = load("res://core/map_holder.tscn").instantiate()
		add_child(mappath)
		mappath.map = path

func load_map(path):
	if path != null:
		log_to_chat("Loading Map")
		map_manager.map_file = path
		map_manager.verify_and_build()
		#map_manager.
		

@rpc("any_peer")
func set_map(path):
	if multiplayer.get_unique_id() == 1:
		set_map(path).rpc()

func prep_for_respawn():
	$RespawnTimer.start()
	log_to_chat("Respawning in 5 seconds")

func on_mouse_entered():
	mouse_over_ui = true

@rpc("call_local")
func load_map_remote():
	load_map(get_node("map_holder").map)


func on_mouse_exited():
	mouse_over_ui = false

func log_to_chat(msg):
	main_node.log_to_chat(msg)

func _on_respawn_timer_timeout():
	log_to_chat("Respawning Player")
	var id = multiplayer.get_unique_id()
	if id != 1:
		rpc_id(1, "instance_player", id)
	else:
		instance_player(id)

@rpc("any_peer")
func instance_player(id):
	var player_instance = load("res://actors/player.tscn").instantiate()
	player_instance.name = str(id)
	add_child(player_instance)
	#$OutOfBounds.connect("body_entered", Callable(player_instance, "out_of_bounds"))
	if id == multiplayer.get_unique_id():
		Global.player = player_instance
	if Global.game_mode == "":
		player_instance.global_transform.origin = Global.spawnpoint
	elif Global.game_mode == "Deathmatch":
		player_instance.global_transform.origin = Global.spawnpoints.pick_random()

func player_joined(id):
	rpc_id(id, "load_map_remote")

func add_bots():
	if Global.bots_enabled == false or Global.bot_amount == 0 or Global.game_mode == "":
		return
	add_bot()

func add_bot():
	var bot_instance = load("res://actors/dm_bot.tscn").instantiate()
	bot_instance.name = "Bot " + var_to_str(Global.bot_amount)
	add_child(bot_instance)
	#$OutOfBounds.connect("body_entered", Callable(player_instance, "out_of_bounds"))
	if Global.game_mode == "Deathmatch":
		bot_instance.global_transform.origin = Global.spawnpoints.pick_random()
	Global.bot_amount -= 1
	if Global.bot_amount != 0:
		add_bot()


func _on_map_manager_unwrap_uv_2_complete():
	pass

func ultra():
	Environment.sdfgi_enabled = true


func _on_map_manager_build_complete():
	map_manager.unwrap_uv2()
	navregion.bake_navigation_mesh()
	var id = multiplayer.get_unique_id()
	if id != 1:
		rpc_id(1, "instance_player", id)
	else:
		instance_player(id)
	add_bots()

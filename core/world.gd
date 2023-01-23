extends Node3D

@export var main_node_path : NodePath

var map = null

var prop_num : int = 1
var prop_name : String

var can_rebuild = false

var mouse_over_ui = false

var qodot_map_instance = null

@onready var qodot_map = $NavigationRegion3D/QodotMap
@onready var navregion = $NavigationRegion3D
@onready var main_node = get_node(main_node_path)

var player = null
var spawnpoint : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	Console.register_env("world", self)
	#QodotDependencies.check_dependencies(http_request)

func _physics_process(_delta):
	if !player == null:
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
		navregion.add_child(qodot_map_instance)
		qodot_map.map_file = path
		qodot_map.verify_and_build()

func prep_for_respawn():
	$RespawnTimer.start()
	log_to_chat("Respawning in 5 seconds")

func on_mouse_entered():
	mouse_over_ui = true


func load_map_remote():
	load_map(get_node("map_holder").map)


func on_mouse_exited():
	mouse_over_ui = false

func log_to_chat(msg):
	main_node.log_to_chat(msg)

func _on_respawn_timer_timeout():
	log_to_chat("Respawning Player")
	instance_player(multiplayer.get_unique_id())

func instance_player(id):
	var player_instance = load("res://actors/player.tscn").instantiate()
	player_instance.name = str(id)
	add_child(player_instance)
	if id == multiplayer.get_unique_id():
		player = player_instance
	player_instance.global_transform.origin = spawnpoint


func _on_qodot_map_build_complete():
	qodot_map.unwrap_uv2()
	navregion.bake_navigation_mesh()


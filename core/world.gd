extends Node3D

@export var main_node_path : NodePath

var map = null

var prop_num : int = 1
var prop_name : String

var can_rebuild = false

var mouse_over_ui = false

@onready var tb_loader = $NavigationRegion3D/TBLoader
@onready var navregion = $NavigationRegion3D
@onready var main_node = get_node(main_node_path)
@onready var http_request = $HTTPRequest

var player = null
var spawnpoint : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	http_request.use_threads = true
	#QodotDependencies.check_dependencies(http_request)

func _physics_process(_delta):
	if !player == null:
		pass#get_tree().call_group("bot", "update_target_location", player.global_transform.origin)

func chat(_name, msg):
	main_node.chat(_name, msg)

func load_map(path):
	if path != null:
		log_to_chat("Loading Map")
		tb_loader.map_resource = path
		tb_loader.build_meshes()
		navregion.bake_navigation_mesh()

func prep_for_respawn():
	$RespawnTimer.start()
	log_to_chat("Respawning in 5 seconds")

func on_mouse_entered():
	mouse_over_ui = true


func on_mouse_exited():
	mouse_over_ui = false

func log_to_chat(msg):
	main_node.log_to_chat(msg)

func _on_respawn_timer_timeout():
	log_to_chat("Respawning Player")
	instance_player(multiplayer.get_unique_id())

func instance_player(id):
	var player_instance = load("res://actors/player.tscn").instantiate()
	player_instance.set_multiplayer_authority(id)
	player_instance.name = str(id)
	add_child(player_instance)
	if id == multiplayer.get_unique_id():
		player = player_instance
	player_instance.global_transform.origin = spawnpoint

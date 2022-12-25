extends Spatial

export var main_node_path : NodePath

var player = preload("res://src/actors/player.tscn")
var map = null

var prop_num : int = 1
var prop_name : String

var can_rebuild = false

var mouse_over_ui = false

onready var qodot_map = $QodotMap
onready var main_node = get_node(main_node_path)
onready var http_request = $HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	rpc_config("_instance_player", 1)
	http_request.use_threads = true
	QodotDependencies.check_dependencies(http_request)


func import_map(path):
	var file = File.new()
	file.open(path, File.READ)
	var sbg_text = file.get_as_text()
	map = str2var(sbg_text)
	file.close()

func load_map(path):
	if path != null:
		qodot_map.set_map_file(path)
		qodot_map.verify_and_build()
		qodot_map.unwrap_uv2()
	$AmbiantNoise.play()

func _on_play_button_pressed():
	_instance_player(get_tree().get_network_unique_id())
	rpc("_instance_player", get_tree().get_network_unique_id())

func _instance_player(id):
	$Camera.queue_free()
	main_node.log_to_chat("Instancing Player " + var2str(id))
	var player_instance = player.instance()
	player_instance.set_network_master(id)
	player_instance.name = str(id)
	add_child(player_instance)
	player_instance.global_transform.origin = Vector3(0, 5, 0)


func on_mouse_entered():
	mouse_over_ui = true


func on_mouse_exited():
	mouse_over_ui = false

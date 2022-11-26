extends Spatial

export var master_node : NodePath

var player = preload("res://src/runtime/actors/player.tscn")
var map = null

var prop_num : int = 1
var prop_name : String

onready var qodot_map = $QodotMap

# Called when the node enters the scene tree for the first time.
func _ready():
	rpc_config("_instance_player", 1)

func import_map(path):
	var file = File.new()
	file.open(path, File.READ)
	var sbg_text = file.get_as_text()
	map = str2var(sbg_text)
	file.close()

func load_map(path):
	qodot_map.set_map_file(path)
	qodot_map.verify_and_build()

func _on_play_button_pressed():
	print("Hello World")
	_instance_player(get_tree().get_network_unique_id())
	rpc("_instance_player", get_tree().get_network_unique_id())

func _instance_player(id):
	var player_instance = player.instance()
	player_instance.set_network_master(id)
	player_instance.name = str(id)
	add_child(player_instance)
	player_instance.global_transform.origin = Vector3(0, 5, 0)

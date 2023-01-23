extends Node3D

@export var main_node_path : NodePath

var map = null

var prop_num : int = 1
var prop_name : String

var can_rebuild = false

var mouse_over_ui = false

@onready var qodot_map = $NavigationRegion3D/QodotMap
@onready var navregion = $NavigationRegion3D
@onready var main_node = get_node(main_node_path)

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass#Console.register_env("world_sp", self)
	#QodotDependencies.check_dependencies(http_request)

func _physics_process(_delta):
	if !player == null:
		pass#get_tree().call_group("bot", "update_target_location", player.global_transform.origin)


func load_map(path):
	if path != null:
		qodot_map.map_file = path
		qodot_map.verify_and_build()

func on_mouse_entered():
	mouse_over_ui = true


func _on_qodot_map_build_complete():
	qodot_map.unwrap_uv2()
	navregion.bake_navigation_mesh()


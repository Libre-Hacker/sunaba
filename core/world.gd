extends Node3D

@export var main_node_path : NodePath

var map = null

var prop_num : int = 1
var prop_name : String

var can_rebuild = false

var mouse_over_ui = false

#onready var qodot_map = $QodotMap
@onready var main_node = get_node(main_node_path)
@onready var http_request = $HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	http_request.use_threads = true
	#QodotDependencies.check_dependencies(http_request)

func load_map(path):
	if path != null:
		#qodot_map.set_map_file(path)
		#qodot_map.verify_and_build()
		#qodot_map.unwrap_uv2()
		pass

func on_mouse_entered():
	mouse_over_ui = true


func on_mouse_exited():
	mouse_over_ui = false

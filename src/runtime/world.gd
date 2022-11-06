extends Spatial

export var master_node : NodePath

var player = preload("res://src/runtime/actors/player.tscn")
var map = null

var prop_num : int = 1
var prop_name : String

onready var voxel_mesh = $VoxelMesh

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func import_map(path):
	var file = File.new()
	file.open(path, File.READ)
	var sbg_text = file.get_as_text()
	map = str2var(sbg_text)
	file.close()

func load_map(data):
	for id in data.terrain:
		var sbg_item = data.terrain[id]
		if !sbg_item.type == -1:
			voxel_mesh.set_voxel(sbg_item.position, sbg_item.type)
			voxel_mesh.update_mesh()
		else:
			voxel_mesh.erase_voxel(sbg_item.position)
			voxel_mesh.update_mesh()
	load_props(data.props)

func load_props(prop_data):
	for prop in prop_data:
		var item = prop_data[prop]
		if item.type == 0:
			var ball = load("res://src/runtime/props/table.tscn")
			add_prop_to_scene_with_vectors("Ball", ball, item.position, item.rotation, item.size, item.type, item.custom_properties)
		elif item.type == 1:
			var beach_ball = load("res://src/runtime/props/beach_ball.tscn")
			add_prop_to_scene_with_vectors("Beach Ball", beach_ball, item.position, item.rotation, item.size, item.type, item.custom_properties)
		elif item.type == 2:
			var bg_music = load("res://src/runtime/props/bg_music.tscn")
			add_prop_to_scene_with_vectors("Background Music", bg_music, item.position, item.rotation, item.size, item.type, item.custom_properties)

func add_prop_to_scene_with_vectors(prp_name, prop_source, pos, rot, size, type, custom_properties):
	if prop_num == 1:
		prop_name = prp_name
	else:
		prop_name = prp_name + " " + var2str(prop_num)
	var prop_instance = prop_source.instance()
	prop_instance.name = prop_name
	add_child(prop_instance)
	prop_instance.translation = pos
	prop_instance.rotation = rot
	prop_instance.custom_properties = custom_properties
	
	prop_instance.initialize()
	
	#var pos = Vector3(0,0,0)
	#var rot = Vector3(0,0,0)
	#var size = Vector3(0,0,0)
	prop_num += 1


func _on_play_button_pressed():
	print("Hello World")

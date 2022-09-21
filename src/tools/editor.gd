extends Spatial

onready var voxel_tools = $Editor/VoxelTools
onready var menu_button = $Editor/Toolbar/Menubar/MenuButton
onready var editor_view = $EditorView
onready var toolbar = $Editor/Toolbar
onready var tree = $Editor/Panel/Tree

var root = null
var prop_num : int = 1
var prop_name : String
var path = null
var ball = preload("res://src/tools/props/ball.tscn")
var beach_ball = preload("res://src/tools/props/beach_ball.tscn")

export var props := {}


# Called when the node enters the scene tree for the first time.
func _ready():
	voxel_tools.hide()
	menu_button.get_popup().connect("id_pressed", self, "_on_item_pressed")
	$Editor/Toolbar/Menubar/HelpMenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed_help")
	toolbar.show()
	root = tree.create_item()
	root.set_text(0, "Scene")
	$Editor/Panel/AddButton.get_popup().connect("id_pressed", self, "add_prop")

func _on_item_pressed(id):
	var item_name = menu_button.get_popup().get_item_text(id)
	if id == 0:
		#$Editor/FileDialog.popup()
		$Editor/FileDialog.popup()
	elif id == 1:
		#$Editor/SaveDialog.popup()
		pass
		var file = File.new()
		file.open(path, File.WRITE)
		file.store_string(var2str(editor_view.blocks))
		file.close()
	elif id == 2:
		$Editor/SaveDialog.popup()
	elif id == 3:
		get_tree().change_scene("res://src/main.tscn")
	print(item_name + ' pressed')

func _on_item_pressed_help(id):
	if id == 0:
		$AboutDialog.show()

func show_voxel_tools():
	voxel_tools.show()
	editor_view.block_edit_mode = true

func _object_mode():
	editor_view.block_edit_mode = false
	voxel_tools.hide()

func show_toolbar():
	toolbar.show()


func add_prop(id):
	print("hi")
	if id == 0:
		add_prop_to_scene("Ball", ball, id)
	elif id == 1:
		add_prop_to_scene("Beach Ball", beach_ball, id)


func add_prop_to_scene(prp_name, prop_source, prop_type):
	var prop_item = tree.create_item(root)
	if prop_num == 1:
		prop_name = prp_name
	else:
		prop_name = prp_name + " " + var2str(prop_num)
	prop_item.set_text(0, prop_name)
	var prop_instance = prop_source.instance()
	prop_instance.name = prop_name
	prop_instance.prop_id = prop_num
	add_child(prop_instance)
	
	var pos = Vector3(0,0,0)
	var rot = Vector3(0,0,0)
	var size = Vector3(0,0,0)

	props[prop_num] = {name = prop_name, type = prop_type, position = pos, rotation = rot, size = size}
	print(props[prop_num])

	prop_num += 1
	
func add_prop_to_scene_with_vectors(prp_name, prop_source, pos, rot, size, type):
	var prop_item = tree.create_item(root)
	if prop_num == 1:
		prop_name = prp_name
	else:
		prop_name = prp_name + " " + var2str(prop_num)
	prop_item.set_text(0, prop_name)
	var prop_instance = prop_source.instance()
	prop_instance.name = prop_name
	prop_instance.prop_id = prop_num
	add_child(prop_instance)
	prop_instance.translation = pos
	prop_instance.rotation = rot
	
	#var pos = Vector3(0,0,0)
	#var rot = Vector3(0,0,0)
	#var size = Vector3(0,0,0)

	props[prop_num] = {name = prop_name, type = type, position = pos, rotation = rot, size = size}
	print(props[prop_num])
	prop_num += 1
	
func edit_item():
	var item = tree.get_selected()
	var selected_prop = item.get_text(0)
	if selected_prop == "Scene":
		return
	print(selected_prop)
	var prop = get_node(selected_prop)
	prop.edit_prop()

func update_prop_transform(unique_id: int, pos: Vector3, rot: Vector3, size: Vector3):
	props[unique_id].position = pos
	props[unique_id].rotation = rot
	props[unique_id].size = size
	print(props[unique_id])


func load_props(prop_data):
	for prop in prop_data:
		var item = prop_data[prop]
		if item.type == 0:
			add_prop_to_scene_with_vectors("Ball", ball, item.position, item.rotation, item.size, item.type)
		elif item.type == 1:
			add_prop_to_scene_with_vectors("Beach Ball", beach_ball, item.position, item.rotation, item.size, item.type)

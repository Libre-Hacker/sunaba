extends Panel

onready var add_button = $AddButton
onready var tree = $Tree
onready var scene_root = get_parent()

var root = null

func _ready():
	add_button.get_popup().add_item("Empty MapObject")
	add_button.get_popup().add_item("Ball")
	add_button.get_popup().add_separator()
	add_button.get_popup().add_item("Presets")
	
	add_button.get_popup().connect("id_pressed", self, "_on_item_pressed")
	#var scene = tree.create_item()
	#scene.set_text(0, "Scene")
	root = tree.create_item()
	root.set_text(0, "World")
	#root.set_icon(0, "res://assets/ui/rpgiab_icon_pack_v1.2/16x16/world.png")
	var terrain_map_object = tree.create_item(root)
	terrain_map_object.set_text(0, "Terrain")
	#terrain_map_object.set_icon(0, "res://assets/ui/rpgiab_icon_pack_v1.2/16x16/terrain.png")
	tree.connect("item_selected", self, "_item_selected")
	

func _add_empty_map_object():
	var empty_map_object = tree.create_item(root)
	empty_map_object.set_text(0, "MapObject")
	scene_root._add_empty_map_object()
	#var map_object = preload("res://source/runtime/map_objects/map_object.tscn")
	#var instance = map_object.instance()
	#add_child(instance)

func _add_ball():
	var ball_entry = tree.create_item(root)
	ball_entry.set_text(0, "Ball")
	scene_root._add_ball()
	#var ball = preload("res://source/runtime/map_objects/map_object.tscn")
	#var instance = ball.instance()
	#add_child(instance)

func _on_item_pressed(id):
	var item_name = add_button.get_popup().get_item_text(id)
	if item_name == 'Empty MapObject':
		_add_empty_map_object()
	if item_name == "Ball":
		_add_ball()
		

func _item_selected():
	pass

## Public Methods
func set_scene_root(path : NodePath) -> void:
	if path.is_empty():
		scene_root = null
	else:
		scene_root = path

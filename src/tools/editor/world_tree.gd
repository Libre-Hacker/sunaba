extends Control

onready var add_button = $AddButton
onready var tree = $Tree

func _ready():
	add_button.get_popup().add_item("Empty MapObject")
	add_button.get_popup().add_item("Presets")
	
	add_button.get_popup().connect("id_pressed", self, "_on_item_pressed")
	var root = tree.create_item
	var moItem1 = tree.create_item(root)
	var terrain_map_object = tree.create_item(moItem1)
	terrain_map_object.set_text(0, "Terrain")
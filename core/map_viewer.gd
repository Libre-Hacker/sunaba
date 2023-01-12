extends Node3D

@onready var tb_loader = $TBLoader

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.theme = ThemeManager.theme

func set_map_path(path):
	if path != null:
		tb_loader.map_resource = path
		$Control/Bottombar/Controls/MapFilePath.text = path

func load_map():
	tb_loader.build_meshes()


func open_file_dialog():
	$Control/FileDialog.popup_centered()


func exit():
	get_tree().change_scene_to_file("res://core/main.tscn")

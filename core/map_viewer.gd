extends Node3D

@onready var qodot_map = $QodotMap

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.theme = ThemeManager.theme

func set_map_path(path):
	if path != null:
		qodot_map.map_file = path
		$Control/Bottombar/Controls/MapFilePath.text = path

func load_map():
	qodot_map.verify_and_build()
	qodot_map.unwrap_uv2()
	#qodot_map


func open_file_dialog():
	$Control/FileDialog.popup_centered()


func exit():
	get_tree().change_scene_to_file("res://core/main.tscn")


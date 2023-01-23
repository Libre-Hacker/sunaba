extends Node

@onready var world = $UI/SubViewportContainer/WorldViewport/World3D

var map_path = ""

func _ready() -> void:
	$UI.theme = ThemeManager.theme
	Global.game_started = false
	Global.game_paused = false
	Console.register_env("sp", self)

func quit():
	get_tree().quit()

func _process(_delta):
	if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_R):
		reload()
	if Input.is_key_pressed(KEY_TAB) and Input.is_key_pressed(KEY_Q):
		map_viewer()
	

func reload():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://core/reload.tscn")

func map_viewer():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://core/map_viewer.tscn")


func _on_map_file_selected(path):
	map_path = path
	Console.notify("Map selected - " + map_path)
	
func play(map : String):
	if map_path == "" and !map == "":
		map_path = "res://maps/tbx_" + map + ".map"
	if FileAccess.file_exists(map_path):
		Global.game_started = true
		world.load_map(map_path)
	else: 
		var i = map_path
		map_path = ""
		return "Map file \"" + i + "\" does not exist"

func set_map_file():
	$UI/FileDialog.popup_centered()

extends Node

@onready var world = $UI/SubViewportContainer/WorldViewport/World3D

var map_path = ""

func _ready() -> void:
	$UI.theme = ThemeManager.theme
	Global.game_started = false
	Global.game_paused = false
	Console.register_env("sp", self)
	
	Console.notify(" ")
	Console.notify("Sunaba")
	Console.notify("Version " + Build.version_number)
	Console.notify("Compiled on " + Build.build_date)
	Console.notify("(C) 2022-2023 mintkat")
	Console.notify(" ")
	Console.notify("Be sure go to Options and turn off \"Pause When Active\" or else the map file browser won't work")
	Console.notify(" ")
	
	print("")
	print("Sunaba")
	print("Version " + Build.version_number)
	print("Compiled on " + Build.build_date)
	print("(C) 2022-2023 mintkat")
	print("")
	
	var args = OS.get_cmdline_args()
	var file = args[0]
	if ".map" in file:
		play(file)

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

func play(map = null):
	if map_path == "" and !map == null:
		map_path = map
	if FileAccess.file_exists(map_path):
		Global.game_started = true
		world.load_map(map_path)
	else: 
		var i = map_path
		map_path = ""
		return "Map file \"" + i + "\" does not exist"

func set_map_file():
	$UI/FileDialog.popup_centered()

func play_multiplayer():
	get_tree().change_scene_to_file("res://core/main.tscn")

func get_maps():
	var list = []
	var dir = DirAccess.open("res://maps")
	
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif (not file.begins_with(".")) and file.begins_with("tbx_") and (not file.ends_with(".import")):
			list.append(file)
	
	dir.list_dir_end()
	
	return list
	

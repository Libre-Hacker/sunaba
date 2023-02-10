extends Node

var path : String
var address = "localhost"

@onready var network_manager = $NetworkManager
@onready var chatbox = $UI/Chatbox
@onready var chat_entry = $UI/Bottombar/RoomControls/ChatEntry
@onready var world = $World3D

func _ready() -> void:
	chat_entry.editable = false
	$UI.theme = ThemeManager.theme
	Global.game_started = false
	Global.game_paused = false
	#Console.register_env("sb", self)
	
	#Console.notify(" ")
	#Console.notify("Sunaba")
	#Console.notify("Version " + Build.version_number)
	#Console.notify("Compiled on " + Build.build_date)
	#Console.notify("(C) 2022-2023 mintkat")
	#Console.notify(" ")
	
	#print("")
	#print("Sunaba")
	#print("Version " + Build.version_number)
	#print("Compiled on " + Build.build_date)
	#print("(C) 2022-2023 mintkat")
	#print("")
	
	var args = OS.get_cmdline_args()
	var file = args[0]
	if ".map" in file:
		play(file)

func create_room() -> void:
	if path != null:
		network_manager.create_room()
		$UI/NewRoomDialog.hide()
		$UI/MainMenu.hide()

func enable_chat() -> void:
	chat_entry.editable = true

func log_to_chat(logstring):
	logstring = "Room : " + logstring
	print(logstring)
	chatbox.add_text(logstring)
	chatbox.newline()

func chat(_name , chatstring):
	chatstring = _name + " : " + chatstring
	print(chatstring)
	chatbox.add_text(chatstring)
	chatbox.newline()
	chat_entry.clear()
	#chat_entry.focus_mode = false

func import_world():
	if path == null:
		log_to_chat("No Map File Selected, Defaulting to preloaded map")
	else:
		log_to_chat("Importing world from File - " + path)
	world.load_map_path(path)
	world.load_map(path)


func _on_chat_text_entered(new_text):
	var id = var_to_str(get_tree().get_unique_id())
	network_manager.rpc("chat", id, new_text)
	chat(id, new_text)


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



func _connect():
	network_manager.join_room(address)
	$UI/ConnectDialog.hide()
	$UI/MainMenu.hide()


func _on_address_changed(new_text):
	address = new_text

func play(map = null):
	if map != null:
		path = map
	create_room()

#func play_sp():
	#get_tree().change_scene_to_file("res://core/singleplayer.tscn")

func set_map_file():
	$UI/FileDialog.popup_centered()

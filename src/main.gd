extends Node

var path = null
var network_manager = null

onready var network_manager_enet = $NetworkManagerENet
onready var chatbox = $UI/Chatbox
onready var chat_entry = $UI/Bottombar/RoomControls/ChatEntry
onready var world = $UI/ViewportContainer/WorldViewport/World

func _ready() -> void:
	network_manager = network_manager_enet
	network_manager.connect_to_server()
	chat_entry.editable = false
	$UI.theme = ThemeManager.theme

func create_room() -> void:
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

func chat(id , chatstring):
	chatstring = id + " : " + chatstring
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
	world.load_map(path)


func _on_chat_text_entered(new_text):
	var id = var2str(get_tree().get_network_unique_id())
	network_manager.rpc("chat", id, new_text)
	chat(id, new_text)


func quit():
	get_tree().quit()

func _process(_delta):
	if Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_R):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene("res://src/reload.tscn")

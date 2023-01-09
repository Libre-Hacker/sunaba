extends Node

var match_id : String

var transport = null

export var address_bar : NodePath
export var world : NodePath
export var ui_node : NodePath


onready var server = $HttpServer 
onready var transport_enet = $ENetTransport

func _ready():
	rpc_config("get_world", 1)
	transport = transport_enet
	get_tree().connect("network_peer_connected", self, "_player_joined")

func connect_to_server() -> void:
	join_room("127.0.0.1")

func _on_address_entered(_new_text):
	join_room("127.0.0.1")

func create_room():
	start_http_server()
	transport.create_room()
	get_parent().log_to_chat("Room created")
	get_parent().enable_chat()
	_player_joined(get_tree().get_network_unique_id())
	get_parent().import_world()


func join_room(address):
	transport.join_room(address)


func _on_room_joined(id : String):
	get_parent().log_to_chat("Room joined - " + id)

func _player_joined(id):
	get_parent().log_to_chat(var2str(id) + " has joined")
	get_parent().enable_chat()
	if id == get_tree().get_network_unique_id():
		get_node(world).load_map("user://server/index.map")

func _on_player_status_changed():
	pass

remote func chat(id , chatstring):
	get_parent().chat(id, chatstring)

func get_address():
	var addresses = IP.get_local_addresses()
	var address = addresses[1]
	return address

func start_http_server():
	server.register_router("/", HttpFileRouter.new("user://server"))

func get_map_file():
	pass

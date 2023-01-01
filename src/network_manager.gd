extends Node

var match_id : String

export var address_bar : NodePath
export var world : NodePath
export var ui_node : NodePath

func _ready():
	rpc_config("get_world", 1)
	rpc_config("load_world", 1)

func connect_to_server() -> void:
	get_tree().connect("network_peer_connected", self, "_player_joined")
	join_room("127.0.0.1")

func _on_address_entered(_new_text):
	join_room("127.0.0.1")

func create_room():
	_create_enet_room()

func _create_enet_room():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8070)
	get_tree().set_network_peer(peer)
	get_parent().log_to_chat("Room created")
	get_node(address_bar).text = get_address()
	get_parent().enable_chat()
	get_parent().import_world()
	_player_joined(get_tree().get_network_unique_id())

func join_room(address):
	_join_room_enet(address)

func _join_room_enet(address):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(address, 8070)
	get_tree().set_network_peer(peer)


func load_world(map_data):
	get_node(world).load_map(map_data)

func _on_room_joined(id : String):
	get_parent().log_to_chat("Room joined - " + id)

func _player_joined(id):
	get_parent().log_to_chat(var2str(id) + " has joined")
	get_parent().enable_chat()
	get_node(ui_node).show_play_button()

func _on_player_status_changed():
	pass

remote func chat(id , chatstring):
	get_parent().chat(id, chatstring)

func get_address():
	var addresses = IP.get_local_addresses()
	var address = addresses[1]
	return address


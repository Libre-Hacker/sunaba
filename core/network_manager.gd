extends Node

var match_id : String

var enet_peer = ENetMultiplayerPeer.new()

@export var world : NodePath
@export var ui_node : NodePath


func _ready():
	#rpc_config("get_world_3d", 1)
	multiplayer.multiplayer_peer = null
	#get_tree().connect("peer_connected",Callable(self,"_player_joined"))


	#peer.peer_connected.connect(func(id): _player_joined(id))
	#peer.peer_disconnected.connect(func(id): print("Player disconnected"))
	
	#peer.connection_succeeded.connect(func(id): print("success"))
	#peer.connection_failed.connect(func(id): print("fail"))

func connect_to_server() -> void:
	join_room("127.0.0.1")

func _on_address_entered(_new_text):
	join_room("127.0.0.1")

func create_room():
	enet_peer.create_server(8070)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(_player_joined)
	
	get_parent().log_to_chat("Room created")
	get_parent().enable_chat()
	get_parent().import_world(multiplayer.get_unique_id())


func join_room(address):
	enet_peer.create_client(address, 8070)
	multiplayer.multiplayer_peer = enet_peer


func _on_room_joined(id : String):
	get_parent().log_to_chat("Room joined - " + id)

func _player_joined(id):
	Global.game_started = true
	get_parent().log_to_chat(var_to_str(id) + " has joined")
	get_parent().enable_chat()


func _on_player_status_changed():
	pass

@rpc(any_peer) func chat(id , chatstring):
	get_parent().chat(id, chatstring)

func get_address():
	var addresses = IP.get_local_addresses()
	var address = addresses[1]
	return address

func start_http_server():
	pass#server.register_router("/", HttpFileRouter.new("user://server"))

func get_map_file():
	pass

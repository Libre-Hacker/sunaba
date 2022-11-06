extends Node


var nakama_client : NakamaClient
var nakama_session : NakamaSession
var nakama_socket : NakamaSocket

var match_id : String

export var address_bar : NodePath
export var world : NodePath

func _ready():
	rpc_config("get_world", 1)
	rpc_config("load_world", 1)

func connect_to_server() -> void:
	# Connect to a local Nakama instance using all the default settings.
	nakama_client = Nakama.create_client('defaultkey', 'localhost', 7350, 'http', 
		Nakama.DEFAULT_TIMEOUT, NakamaLogger.LOG_LEVEL.ERROR)
 
	# Login to Nakama using "device authentication".
	var device_id = OS.get_unique_id()
	nakama_session = yield(nakama_client.authenticate_device_async(device_id, "Example"), 'completed')
	if nakama_session.is_exception():
		print ("Unable to connect to Nakama")
		get_tree().quit()
 
	# Open a realtime socket to Nakama.
	nakama_socket = Nakama.create_socket_from(nakama_client)
	yield(nakama_socket.connect_async(nakama_session), "completed")
	
	# We can configure OnlineMatch before using it:
	OnlineMatch.min_players = 1
	OnlineMatch.max_players = 10
	OnlineMatch.client_version = 'dev'
	OnlineMatch.ice_servers = [{ "urls": ["stun:stun.l.google.com:19302"] }]
	OnlineMatch.use_network_relay = OnlineMatch.NetworkRelay.AUTO
 
	# Connect to all of OnlineMatch's signals.
	OnlineMatch.connect("match_created", self, "_on_room_created")
	OnlineMatch.connect("match_joined", self, "_on_room_joined")
	OnlineMatch.connect("player_joined", self, "_player_joined")
	
	get_parent().log_to_chat("Connected to Nakama!")


func _on_address_entered(new_text):
	OnlineMatch.join_match(nakama_socket, new_text)

func create_room():
	#print("Create_room")
	OnlineMatch.create_match(nakama_socket)

func _on_room_created(id):
	get_parent().log_to_chat("Room created")
	get_node(address_bar).text = id
	get_parent().enable_chat()
	get_parent().import_world()

func load_world(map_data):
	get_node(world).load_map(map_data)

func _on_room_joined(id : String):
	get_parent().log_to_chat("Room joined - " + id)

func _player_joined(player):
	get_parent().log_to_chat(player.username + " has joined")
	get_parent().enable_chat()
	if get_tree().get_network_unique_id() == 1:
		var map_data = get_node(world).map
		if player.peer_id == get_tree().get_network_unique_id():
			get_node(world).load_map(map_data)
		else:
			rpc("load_world", map_data)

func _on_player_status_changed():
	pass

remote func chat(id , chatstring):
	get_parent().chat(id, chatstring)

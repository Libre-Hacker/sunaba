extends Node


var nakama_client: NakamaClient
var nakama_session: NakamaSession
var nakama_socket: NakamaSocket


func _ready() -> void:
	connect_to_server()


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
	OnlineMatch.connect("error", self, "_on_OnlineMatch_error")
	OnlineMatch.connect("disconnected", self, "_on_OnlineMatch_disconnected")
	OnlineMatch.connect("match_created", self, "_on_OnlineMatch_match_created")
	OnlineMatch.connect("match_joined", self, "_on_OnlineMatch_match_joined")
	OnlineMatch.connect("matchmaker_matched", self, "_on_OnlineMatch_matchmaker_matched")
	OnlineMatch.connect("player_joined", self, "_on_OnlineMatch_player_joined")
	OnlineMatch.connect("player_left", self, "_on_OnlineMatch_player_left")
	OnlineMatch.connect("player_status_changed", self, "_on_OnlineMatch_player_status_changed")
	OnlineMatch.connect("match_ready", self, "_on_OnlineMatch_match_ready")
	OnlineMatch.connect("match_not_ready", self, "_on_OnlineMatch_match_not_ready")
	
	print ("Connected to Nakama!")

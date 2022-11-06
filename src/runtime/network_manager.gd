extends Node

var match_id : String

export var address_bar : NodePath
export var world : NodePath

func _ready():
	rpc_config("get_world", 1)
	rpc_config("load_world", 1)

func connect_to_server() -> void:
	pass

func _on_address_entered(new_text):
	#OnlineMatch.join_match(nakama_socket, new_text)
	pass

func create_room():
	#print("Create_room")
	#OnlineMatch.create_match(nakama_socket)
	pass

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

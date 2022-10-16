extends Spatial

export var online : bool
export var use_web_sockets : bool

var player = preload("res://src/runtime/actors/player.tscn")
var map = null


var player_paused = false

var prop_num : int = 1
var prop_name : String

onready var voxel_mesh = $VoxelMesh
onready var loading_bar = $LoadingScreen/Panel/ProgressBar


func _ready():
	get_tree().connect("network_peer_connected", self, "_connected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	$LoadingScreen.show()
	$Hud.show()
	$Hud/Menu.popup()
	loading_bar.value = 0
	if online:
		if GameManager.is_host:
			log_to_chat("Creating Game")
			if use_web_sockets:
				var server = WebSocketServer.new()
				server.listen(8070, PoolStringArray(), true)
				get_tree().set_network_peer(server)
			else:
				var peer = NetworkedMultiplayerENet.new()
				peer.create_server(8070)
				get_tree().set_network_peer(peer)
			#_instance_player(get_tree().get_network_unique_id())
			_import_map(GameManager.path)
			
		else:
			log_to_chat("Joining Room")
			if use_web_sockets:
				var client = WebSocketClient.new()
				var url = "ws://" + GameManager.ip_ad + ":" + str(8070)
				var error = client.connect_to_url(url, PoolStringArray(), true)
				get_tree().set_network_peer(client)
			else:
				var peer = NetworkedMultiplayerENet.new()
				peer.create_client(GameManager.ip_ad, 8070)
				get_tree().set_network_peer(peer)
			
			#_instance_player(get_tree().get_network_unique_id())
		loading_bar.value = 1
		rpc_config("_chat", 1)
		rpc_config("_instance_player", 1)
		rpc_config("_load_map", 1)
		rpc_config("load_props", 1)
	else:
		loading_bar.value = 1
		_import_map(GameManager.path)


func _process(delta):
	if Input.is_key_pressed(KEY_TAB):
		if !player_paused:
			$Hud/Menu.popup()
			player_paused = true
		else:
			$Hud/Menu.hide()
			player_paused = false

func menu_button():
	$Hud/Menu.popup()


func _connected(id):
	print("Connected to server")
	log_to_chat("Player " + var2str(id) + " has connected to the room")
	#_instance_player(id)
	if GameManager.is_host:
		rpc("_load_map", map)


func _player_disconnected(id):
	log_to_chat("Player " + var2str(id) + " has disconnected from the room")
	
	if has_node(str(id)):
		get_node(str(id)).queue_free()



func _server_disconnected():
	OS.alert("You have been disconected from the room")
	reset_network_connection()


func _connection_failed():
	OS.alert("Failed to connect to the room")
	reset_network_connection()


func reset_network_connection():
	if get_tree().has_network_peer():
		get_tree().network_peer = null
	get_tree().change_scene("res://src/main.tscn")


func log_to_chat(logstring):
	logstring = "Room : " + logstring
	print(logstring)
	$Chatbox.add_text(logstring)
	$Chatbox.newline()


func _import_map(path):
	var file = File.new()
	file.open(path, File.READ)
	var sbg_text = file.get_as_text()
	map = str2var(sbg_text)
	loading_bar.value = 2
	for id in map.terrain:
		var sbg_item = map.terrain[id]
		if !sbg_item.type == -1:
			voxel_mesh.set_voxel(sbg_item.position, sbg_item.type)
			voxel_mesh.update_mesh()
		else:
			voxel_mesh.erase_voxel(sbg_item.position)
			voxel_mesh.update_mesh()
	loading_bar.value = 3
	load_props(map.props)
	rpc("load_props")
	loading_bar.value = 4
	$LoadingScreen.hide()
	file.close()
	
	

func _load_map(data):
	for id in data.terrain:
		var sbg_item = data.terrain[id]
		if !sbg_item.type == -1:
			voxel_mesh.set_voxel(sbg_item.position, sbg_item.type)
			voxel_mesh.update_mesh()
		else:
			voxel_mesh.erase_voxel(sbg_item.position)
			voxel_mesh.update_mesh()
	load_props(data.props)
	loading_bar.value = 4
	$LoadingScreen.hide()



func _instance_player(id):
	var player_instance = player.instance()
	player_instance.set_network_master(id)
	player_instance.name = str(id)
	add_child(player_instance)
	player_instance.global_transform.origin = Vector3(0, 5, 0)



func load_props(prop_data):
	for prop in prop_data:
		var item = prop_data[prop]
		if item.type == 0:
			var ball = load("res://src/runtime/props/table.tscn")
			add_prop_to_scene_with_vectors("Ball", ball, item.position, item.rotation, item.size, item.type, item.custom_properties)
		elif item.type == 1:
			var beach_ball = load("res://src/runtime/props/beach_ball.tscn")
			add_prop_to_scene_with_vectors("Beach Ball", beach_ball, item.position, item.rotation, item.size, item.type, item.custom_properties)
		elif item.type == 2:
			var bg_music = load("res://src/runtime/props/bg_music.tscn")
			add_prop_to_scene_with_vectors("Background Music", bg_music, item.position, item.rotation, item.size, item.type, item.custom_properties)


func add_prop_to_scene_with_vectors(prp_name, prop_source, pos, rot, size, type, custom_properties):
	if prop_num == 1:
		prop_name = prp_name
	else:
		prop_name = prp_name + " " + var2str(prop_num)
	var prop_instance = prop_source.instance()
	prop_instance.name = prop_name
	add_child(prop_instance)
	prop_instance.translation = pos
	prop_instance.rotation = rot
	prop_instance.custom_properties = custom_properties
	
	prop_instance.initialize()
	
	#var pos = Vector3(0,0,0)
	#var rot = Vector3(0,0,0)
	#var size = Vector3(0,0,0)
	prop_num += 1


func _on_chat_entry_entered(new_text):
	rpc("_chat", new_text, var2str(get_tree().get_network_unique_id()))
	_chat(new_text, var2str(get_tree().get_network_unique_id()))
	$ChatEntry.clear()


func _chat(logstring, username):
	logstring = username + " : " + logstring
	print(logstring)
	$Chatbox.add_text(logstring)
	$Chatbox.newline()


func _exit_game():
	reset_network_connection()


func _join_game():
	_instance_player(get_tree().get_network_unique_id())
	rpc("_instance_player", get_tree().get_network_unique_id())
	#$Hud/Menu/VBoxContainer/Button.disabled
	#$Hud/Menu/VBoxContainer/Button.visible = false


func _resume():
	$Hud/Menu.hide()

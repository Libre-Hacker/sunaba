extends Spatial

export var online : bool

var player = preload("res://src/actors/player.tscn")
var networked_player = preload("res://src/actors/networked_player.tscn")
var map = null

var prop_num : int = 1
var prop_name : String
var ball = preload("res://src/runtime/props/ball.tscn")
var beach_ball = preload("res://src/runtime/props/beach_ball.tscn")

onready var voxel_mesh = $VoxelMesh
onready var loading_bar = $LoadingScreen/Panel/ProgressBar

func _ready():
	get_tree().connect("network_peer_connected", self, "_connected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	$LoadingScreen.show()
	$Hud.hide()
	loading_bar.value = 0
	if online:
		if GameManager.is_host:
			log_to_chat("Creating Game")
			var peer = NetworkedMultiplayerENet.new()
			peer.create_server(8070)
			get_tree().set_network_peer(peer)
			loading_bar.value = 1
			loading_bar.value = 1
			_import_map(GameManager.path)
			#_instance_player(get_tree().get_network_unique_id())
			
		else:
			log_to_chat("Joining Room")
			var peer = NetworkedMultiplayerENet.new()
			peer.create_client(GameManager.ip_ad, 8070)
			get_tree().set_network_peer(peer)
			loading_bar.value = 1
			_import_map(GameManager.path)
			#_instance_player(get_tree().get_network_unique_id())
	else:
		loading_bar.value = 1
		_import_map(GameManager.path)


func _connected(id):
	print("Connected to server")
	log_to_chat("Player " + var2str(id) + " has connected to the room")
	#_instance_player(id)


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
	loading_bar.value = 4
	
	if !online:
		var player_instance = player.instance()
		player_instance.name == "Lulu"
		add_child(player_instance)
		player_instance.global_transform.origin = Vector3(0, 5, 0)
		loading_bar.value = 5
		$LoadingScreen.hide()
		
	file.close()
	
	

func _load_map():
	for id in map:
		var sbg_item = map[id]
		if !sbg_item.type == -1:
			voxel_mesh.set_voxel(sbg_item.position, sbg_item.type)
			voxel_mesh.update_mesh()
		else:
			voxel_mesh.erase_voxel(sbg_item.position)
			voxel_mesh.update_mesh()
	loading_bar.value = 3
	_instance_player(get_tree().get_network_unique_id())



func _instance_player(id):
	var player_instance = networked_player.instance()
	player_instance.set_network_master(id)
	player_instance.name == str(id)
	add_child(player_instance)
	player_instance.global_transform.origin = Vector3(0, 5, 0)
	loading_bar.value = 4
	$LoadingScreen.hide()



func load_props(prop_data):
	for prop in prop_data:
		var item = prop_data[prop]
		if item.type == 0:
			add_prop_to_scene_with_vectors("Ball", ball, item.position, item.rotation, item.size, item.type)
		elif item.type == 1:
			add_prop_to_scene_with_vectors("Beach Ball", beach_ball, item.position, item.rotation, item.size, item.type)


func add_prop_to_scene_with_vectors(prp_name, prop_source, pos, rot, size, type):
	if prop_num == 1:
		prop_name = prp_name
	else:
		prop_name = prp_name + " " + var2str(prop_num)
	var prop_instance = prop_source.instance()
	prop_instance.name = prop_name
	add_child(prop_instance)
	prop_instance.translation = pos
	prop_instance.rotation = rot
	
	#var pos = Vector3(0,0,0)
	#var rot = Vector3(0,0,0)
	#var size = Vector3(0,0,0)
	prop_num += 1


func _on_chat_entry_entered(new_text):
	rpc("_chat", new_text, var2str(get_tree().get_network_unique_id()))
	$ChatEntry.clear()


func _chat(logstring, username):
	logstring = username + " : " + logstring
	print(logstring)
	$Chatbox.add_text(logstring)
	$Chatbox.newline()

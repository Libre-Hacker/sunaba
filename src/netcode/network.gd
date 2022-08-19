extends Node

const DEFAULT_PORT = 5555
const MAX_CLIENTS = 20

var server = null
var client = null

var ip_address = "127.0.0.1"

func _ready():
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("server_disconnected", self, "server_disconnected")
	get_tree().connect("connection_failed", self, "connection_failed")

func create_server():
	print("Creating Server")
	
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)

func join_server():
	print("Joining Server")
	
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)

func connected_to_server():
	print("Connected to server")

func server_disconnected():
	OS.alert("You have been disconected from the server")
	
	reset_network_connection()

func connection_failed():
	OS.alert("Failed to connect to the server")
	reset_network_connection()


func reset_network_connection():
	if get_tree().has_network_peer():
		get_tree().network_peer = null

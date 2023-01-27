extends Node

@onready var peer = ENetMultiplayerPeer.new()

func _ready():
	pass#peer = ENetMultiplayerPeer.new()

func join_room(address):
	peer.create_client(address, 8070)
	multiplayer.multiplayer_peer = peer

func create_room():
	peer.create_server(8070)
	multiplayer.multiplayer_peer = peer

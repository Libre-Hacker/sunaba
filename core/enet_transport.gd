extends Node

func join_room(address):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(address, 8070)
	get_tree().set_multiplayer_peer(peer)

func create_room():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(8070)
	get_tree().set_multiplayer_peer(peer)

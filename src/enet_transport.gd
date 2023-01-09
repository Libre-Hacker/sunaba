extends Node

func join_room(address):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(address, 8070)
	get_tree().set_network_peer(peer)

func create_room():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8070)
	get_tree().set_network_peer(peer)

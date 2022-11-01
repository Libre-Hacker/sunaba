extends Node

var path = null

onready var network_manager = $NetworkManager

func create_room():
	network_manager.create_room()

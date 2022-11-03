extends Node

var path = null

onready var network_manager = $NetworkManager

func _ready() -> void:
	network_manager.connect_to_server()

func create_room() -> void:
	network_manager.create_room()

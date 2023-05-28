extends Node

@export var map = ""

func _enter_tree(): set_multiplayer_authority(1)

func _ready(): pass#Console.register_env("map_holder", self)

func get_map():
	return map

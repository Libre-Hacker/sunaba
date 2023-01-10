extends Node3D
class_name ps_player

var player = preload("res://actors/player.tscn")

func _ready():
	var player_instance = player.instantiate()
	var id = get_tree().get_unique_id()
	player_instance.set_multiplayer_authority(id)
	player_instance.name = str(id)
	add_child(player_instance)
	player_instance.global_transform.origin = global_transform.origin 

extends Node3D
class_name sp_player

var player = preload("res://actors/player.tscn")


func _ready():
	instance_player()

func instance_player():
	var player_instance = player.instantiate()
	get_parent().get_parent().get_parent().add_child(player_instance)
	get_parent().get_parent().get_parent().player = player_instance
	player_instance.global_transform.origin = global_transform.origin + Vector3(0,5,0)
	#get_parent().get_parent().get_parent().spawnpoint = global_transform.origin + Vector3(0,5,0)

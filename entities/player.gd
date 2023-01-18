extends Node3D
class_name ps_player

var player = preload("res://actors/player.tscn")

func _ready():
	if Global.game_started:
		var id = multiplayer.get_unique_id()
		instance_player(id)
	
func instance_player(id):
	var player_instance = player.instantiate()
	player_instance.set_multiplayer_authority(id)
	player_instance.name = str(id)
	get_parent().get_parent().get_parent().add_child(player_instance)
	if id == multiplayer.get_unique_id():
		get_parent().get_parent().get_parent().player = player_instance
	player_instance.global_transform.origin = global_transform.origin + Vector3(0,5,0)
	get_parent().get_parent().get_parent().spawnpoint = global_transform.origin + Vector3(0,5,0)

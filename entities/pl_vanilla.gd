extends Node3D

var player = preload("res://actors/player.tscn")

@export var fgd_block = ["player"] 

@export var fgd_model = {
  "path": "assets/models/tbmodels/playermodel.gltf",
  "scale": 28
}

func _process(delta):
	if Global.is_networked_game:
		Global.spawnpoint = global_transform.origin + Vector3(0,1,0)
		Global.spawnpoints.append(global_transform.origin + Vector3(0,1,0))
	else :
		instance_player()

func instance_player():
	var player_instance = player.instantiate()
	get_parent().get_parent().get_parent().add_child(player_instance)
	Global.player = player_instance
	player_instance.global_transform.origin = global_transform.origin + Vector3(0,5,0)
	#get_parent().get_parent().get_parent().spawnpoint = global_transform.origin + Vector3(0,5,0)

extends Spatial
class_name ps_player

var player = preload("res://src/actors/player.tscn")

func _ready():
	var player_instance = player.instance()
	var id = get_tree().get_network_unique_id()
	player_instance.set_network_master(id)
	player_instance.name = str(id)
	add_child(player_instance)
	player_instance.global_transform.origin = global_transform.origin 

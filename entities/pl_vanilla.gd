extends Node3D


func _ready():
	get_parent().get_parent().get_parent().spawnpoint = global_transform.origin + Vector3(0,1,0)

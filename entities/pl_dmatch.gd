extends Node3D

# Called when the node enters the scene tree for the first time.
func _process(delta):
	Global.spawnpoints.append(global_transform.origin + Vector3(0,1,0))

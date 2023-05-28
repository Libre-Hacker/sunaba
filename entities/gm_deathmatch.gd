extends Node3D

func _enter_tree(): if Global.is_networked_game: set_multiplayer_authority(1)

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game_mode = "Deathmatch"


func _process(delta):
	var spawnpoints : Array
	
	if is_multiplayer_authority():
		spawnpoints = Global.spawnpoints
	else:
		Global.spawnpoints = spawnpoints
	

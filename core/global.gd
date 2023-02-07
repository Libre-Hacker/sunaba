extends Node


var game_started : bool = false

var game_paused : bool = false

var is_networked_game = false

var spawnpoint : Vector3

var spawnpoints : Array

var game_mode : String = ""

var player_model : String = "male"

var player = null

func _ready():
	set_to_default()

func set_to_default():
	game_started = false
	game_paused = false
	game_mode = ""

func _physics_process(_delta):
	if !player == null:
		get_tree().call_group("enemy", "update_target_location", player.global_transform.origin)

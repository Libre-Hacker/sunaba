extends Node


var game_started : bool = false

var game_paused : bool = false

var spawnpoints : Array

var game_mode : String = ""

func _ready():
	set_to_default()

func set_to_default():
	game_started = false
	game_paused = false
	game_mode = ""

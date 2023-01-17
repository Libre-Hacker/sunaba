extends Node

var use_native_fd : bool
var online_play_enabled : bool
var version_number : String

var flags = preload("res://flags.tres")

func _ready():
	use_native_fd = flags.use_native_fd
	online_play_enabled = flags.online_play_enabled
	version_number = flags.version_number
	print("Sunaba v" + version_number + " | (C) 2022-2023 mintkat")

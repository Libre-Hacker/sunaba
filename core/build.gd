extends Node

var use_native_fd : bool
var online_play_enabled : bool
var version_number : String
var build_date : String

#var flags = preload("res://flags.tres")

func _ready():
	#use_native_fd = flags.use_native_fd
	#online_play_enabled = flags.online_play_enabled
	#version_number = flags.version_number
	pass#build_date = flags.build_date
	#print("Toonbox v" + version_number + " | (C) 2022-2023 mintkat")
	
	#add_text("Version " + Build.version_number)
	#add_text("Compiled on " + Build.build_date)
	#add_text("(C) 2022-2023 mintkat")

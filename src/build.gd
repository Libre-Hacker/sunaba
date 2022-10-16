extends Node

var use_native_fd : bool

var flags = preload("res://flags.tres")

func _ready():
	use_native_fd == flags.use_native_fd

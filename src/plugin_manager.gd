extends Node


func _ready():
	_load_pck("res://extensions/mod.pck")

func _load_pck(pck : String):
	# This could fail if, for example, mod.pck cannot be found.
	var success = ProjectSettings.load_resource_pack(pck)

	if success:
		# Now one can use the assets as if they had them in the project from the start.
		print("loaded plugin - " + pck)
		#var imported_scene = load("res://test.tscn")
		#var instance = imported_scene.instance()
		#add_child(instance)

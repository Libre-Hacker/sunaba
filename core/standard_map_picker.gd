extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	get_maps()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_maps():
	var dir = DirAccess.open("res://maps")
	
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif (not file.ends_with(".import")) and file.ends_with(".map"):
			$OptionButton.add_item(file)
	
	dir.list_dir_end()
	

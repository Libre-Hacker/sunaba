extends Panel

var tt_root = null
var tt_weapons = null
var tt_misc = null

@onready var tool_tree = $TabBar/TabContainer/Tools/Tree

# Called when the node enters the scene tree for the first time.
func _ready():
	tt_root = tool_tree.create_item()
	tt_root.set_text(0, "tools")
	get_tools()
	
	

func get_tools():
	var dir = DirAccess.open("res://tools/")
	
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif (not file.ends_with(".import")) and file.ends_with(".tscn"):
			var tool_name = file.left(-5)
			add_tool_to_tree(tool_name)
	
	dir.list_dir_end()
	


func add_tool_to_tree(tool_name):
	var item = tool_tree.create_item()
	item.set_text(0, tool_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

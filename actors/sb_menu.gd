extends Panel

var tt_root = null
var tt_weapons = null
var tt_misc = null

@onready var tool_tree = $TabBar/TabContainer/Tools/Tree

# Called when the node enters the scene tree for the first time.
func _ready():
	tt_root = tool_tree.create_item()
	tt_root.set_text(0, "tools")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

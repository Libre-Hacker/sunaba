extends WindowDialog


var root = null


onready var tree = $Tabs/TabContainer/Music/Tree


func _ready():
	root = tree.create_item()
	var music1 = tree.create_item(root)
	var music2 = tree.create_item(root)
	music1.set_text(0, "Funky Disco")
	music2.set_text(0, "Hau_oli City")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Window

@export var netman_path : NodePath

@onready var ip_address = $TabBar/TabContainer/Online/LineEdit.text
@onready var netman = get_node(netman_path)

func _connect():
	netman.join_room(ip_address)
	get_parent().get_node("MainMenu").hide()
	hide()

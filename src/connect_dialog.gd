extends WindowDialog

export var netman_path : NodePath

onready var ip_address = $LineEdit.text
onready var netman = get_node(netman_path)


func _connect():
	netman.join_room(ip_address)

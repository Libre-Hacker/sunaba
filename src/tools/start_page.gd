extends Panel


export var network_protocol = "WebSockets"

func _ready():
	Global.connect("toggle_network_setup", self, "_toggle_network_setup")
	Network.network_protocol = network_protocol

func _on_ip_address_changed(new_text):
	Network.ip_address = new_text

func _on_host():
	Network.create_server()
	get_parent().show_toolbar()
	hide()
	$StartWindow.hide()
	#Global.emit_signal("instance_player", get_tree().get_network_unique_id())

func _on_join():
	Network.join_server()
	$StartWindow.show_page3()
	
	#Global.emit_signal("instance_player", get_tree().get_network_unique_id())

func _toggle_network_setup(visable_toggle):
	visible = visable_toggle

func new_game():
	get_parent().show_toolbar()
	hide()
	$StartWindow.hide()


func _on_GEButton_pressed():
	get_parent().show_toolbar()
	hide()
	$StartWindow.hide()
	

extends Panel

var file_selected = false

func _ready():
	$Panel2/HBoxContainer/Button.get_popup().connect("id_pressed", self, "_on_item_pressed")
	$Panel2/HBoxContainer/Button2.get_popup().connect("id_pressed", self, "_on_editor_item_pressed")

func _open_file(path):
	if ".sbvx" in path:
		GameManager.path = path
		$Panel/TextBox/Label.text = path
		file_selected = true
	else:
		OS.alert(path + " is not an .sbvx fie")
	
	#get_tree().change_scene("res://src/game.tscn")


func on_ip_address_changed(new_text):
	Network.ip_address = new_text


func join_game():
	if file_selected:
		Network.join_server()
		get_tree().change_scene("res://src/game.tscn")
	else:
		OS.alert(".sbg file not found")


func host_game():
	if file_selected:
		Network.create_server()
		get_tree().change_scene("res://src/game.tscn")
	else:
		OS.alert(".sbg file not found")


func on_file_button_pressed():
	#if OS.nam
		#$NativeDialogOpenFile.show()
	#else:
	$FileDialog.show()


func _on_NativeDialogOpenFile_files_selected(files):
	var path = files[0]
	if ".sbvx" in path:
		GameManager.path = path
		$Panel/TextBox/Label.text = path
		file_selected = true
	else:
		OS.alert(path + " is not an .sbg fie")

func _on_editor_item_pressed(id):
	if id == 0:
		get_tree().change_scene("res://src/tools/main.tscn")

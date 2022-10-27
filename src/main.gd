extends Control

var use_native_dialogs : bool = false

var room_name : String
var map_path : String

func _ready():
	$Panel2/HBoxContainer/Button.get_popup().connect("id_pressed", self, "_menu_pressed")
	$Panel2/HBoxContainer/MenuButton.get_popup().connect("id_pressed", self, "_menu_one")
	GameManager.room_name = ""
	GameManager.path = ""
	GameManager.is_host = false
	if OS.get_name() == "HTML5":
		$Panel2/HBoxContainer/Button.show()
	else:
		$Panel2/HBoxContainer/Button.hide()

func _on_new_roon_button_pressed():
	$NewRoomDialog.popup()
	GameManager.room_name = ""
	GameManager.path = ""
	GameManager.is_host = false


func _on_map_editor_button_pressed():
	get_tree().change_scene("res://src/tools/editor.tscn")


func _file_button_pressed():
	if OS.get_name() == "Windows" and Build.use_native_fd:
		#$NativeDialogOpenFile.show()
		pass
	else:
		$CustomFileDialog.popup()

func _menu_pressed(id):
	if id == 0:
		$DownloadFileDialog.popup()
	if id == 1:
		$MapTextEditor.popup()


func _menu_one(id):
	if id == 0:
		$SettingsDialog.popup()
	elif id == 1:
		get_tree().quit()


func _on_file_selected(path):
	GameManager.path = path
	$NewRoomDialog/Panel/Label.text = path


func _on_room_name_changed(new_text):
	GameManager.room_name = new_text


func _create_room():
	if room_name == "":
		#OS.alert("Please choose a name for your room")
		#return
		GameManager.room_name = "Hello World"
	if GameManager.path == "":
		if $NewRoomDialog/Panel/Label.text == "":
			OS.alert("Please choose a snb file")
			return
		else:
			GameManager.path = $NewRoomDialog/Panel/Label.text
	if !".snb" in  GameManager.path:
		OS.alert("File is not a snb file")
		return
	GameManager.room_name = room_name
	GameManager.is_host = true
	get_tree().change_scene("res://src/runtime/game.tscn")



func play():
	GameManager.is_host = false
	get_tree().change_scene("res://src/runtime/game.tscn")



func _download_file(path):
	var file = File.new()
	file.open(path, File.READ)
	var sbg_text = file.get_as_text()
	JavaScript.download_buffer(sbg_text.to_utf8(), "map.sbvx")


func _on_NativeDialogOpenFile_files_selected(files: PoolStringArray):
	var path = files[0]
	_on_file_selected(path)


func _on_ip_address_changed(new_text):
	GameManager.ip_ad = new_text


func _on_play_button_pressed():
	$IpAddressDialog.popup()

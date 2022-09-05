extends Control

var room_name: String
var map_path : String


func _ready():
	$NewRoomDialog/Panel/MenuButton.get_popup().connect("id_pressed", self, "_id_pressed")
	$Button.get_popup().connect("id_pressed", self, "_menu_pressed")
	GameManager.room_name = ""
	GameManager.path = map_path
	GameManager.is_host = false

func _on_new_roon_button_pressed():
	$NewRoomDialog.popup()
	GameManager.room_name = ""
	GameManager.path = ""
	GameManager.is_host = false


func _on_map_editor_button_pressed():
	get_tree().change_scene("res://src/tools/editor.tscn")


func _id_pressed(id):
	if id == 0:
		$FileDialog.popup()
	if id == 1:
		$CustomFileDialog.popup()

func _menu_pressed(id):
	if id == 0:
		$DownloadFileDialog.popup()
	if id == 1:
		$MapTextEditor.popup()


func _on_file_selected(path):
	GameManager.path = path
	$NewRoomDialog/Panel/Label.text = path


func _on_room_name_changed(new_text):
	GameManager.room_name = new_text


func _create_room():
	if GameManager.room_name == "":
		#OS.alert("Please choose a name for your room")
		#return
		GameManager.room_name = "Hello World"
	elif GameManager.path == "":
		OS.alert("Please choose a map")
		return
	GameManager.room_name = room_name
	GameManager.is_host = true
	get_tree().change_scene("res://src/game.tscn")



func play():
	GameManager.is_host = false
	get_tree().change_scene("res://src/game.tscn")



func _download_file(path):
	var file = File.new()
	file.open(path, File.READ)
	var sbg_text = file.get_as_text()
	JavaScript.download_buffer(sbg_text.to_utf8(), "map.sbvx")

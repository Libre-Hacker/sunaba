extends Node

onready var room_controls = $Bottombar/RoomControls

func _ready():
	$TopBar/Menubar/MenuButtonGame.get_popup().connect("id_pressed", self, "_game_menu")
	$TopBar/Menubar/MenuButtonTools.get_popup().connect("id_pressed", self, "_tools_menu")
	if OS.get_name() == "HTML5":
		$TopBar/AddressBar.editable = false
	$Bottombar/RoomControls/PlayButton.disabled = true
	#room_controls.hide()

func show_play_button():
	$Bottombar/RoomControls/PlayButton.disabled = false
	#room_controls.show()

func _game_menu(id):
	if id == 0:
		print(id)
	elif id == 1:
		$NewRoomDialog.popup()

func _tools_menu(id):
	if id == 0:
		pass
	elif id == 1:
		$SettingsDialog.popup()


func _on_file_button_pressed():
	$FileDialog.popup()

func _on_file_selected(path):
	get_parent().path = path
	$NewRoomDialog/MapPath.text = path

func _on_NativeDialogOpenFile_files_selected(files: PoolStringArray):
	var path = files[0]
	if path != null:
		_on_file_selected(path)


func _on_play_button_pressed():
	$Bottombar/RoomControls/PlayButton.hide()

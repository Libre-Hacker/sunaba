extends Node

@onready var room_controls = $Bottombar/RoomControls

func  _ready():
	$MainMenu.show()
	$PauseMenu.hide()
	#$NewRoomDialog/NewRoom/MapPath/Button.get_popup().id_pressed.connect(_on_file_menu_pressed)

func _on_create_button_pressed():
	$NewRoomDialog.popup_centered()

func _on_sb_pressed():
	$SettingsDialog.popup_centered()

func _on_file_button_pressed():
	$UserFileDialog.popup_centered()


func _on_file_menu_pressed(id):
	if id == 0:
		$MapDialog.popup_centered()
	elif id == 1:
		$UserFileDialog.popup_centered()

func _on_file_selected(path):
	get_parent().path = path
	$NewRoomDialog/NewRoom/MapPath.text = path
	#Console.notify("Map selected - " + path)

func _on_NativeDialogOpenFile_files_selected(files: PackedStringArray):
	var path = files[0]
	if path != null:
		_on_file_selected(path)



func _on_connect_button_pressed():
	if Build.online_play_enabled:
		$ConnectDialog.popup_centered()
	else :
		OS.alert("Multiplayer is not supported in this build.")


func _on_connect_dialog_close_requested():
	$ConnectDialog.hide()


func _on_file_dialog_close_requested():
	$MapDialog.hide()


func _on_new_room_dialog_close_requested():
	$NewRoomDialog.hide()

func _process(_delta):
	if Global.game_started:
		if Global.game_paused:
			$PauseMenu.show()
		else: 
			$PauseMenu.hide()

func unpause():
	$PauseMenu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.game_paused = false


func _on_map_selected():
	var map = $MapDialog/StandardMapPicker/OptionButton.text + ".map"
	var map_path = "res://maps/" + map
	$MapDialog.hide()
	_on_file_selected(map_path)

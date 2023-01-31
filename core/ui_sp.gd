extends Node

@onready var room_controls = $Bottombar/RoomControls

func  _ready():
	$MainMenu.show()
	$PauseMenu.hide()

func _on_create_button_pressed():
	OS.alert("Under construction.")#$NewRoomDialog.popup_centered()

func _on_sb_pressed():
	$SettingsDialog.popup_centered()


func _on_file_button_pressed():
	$FileDialog.popup_centered()

func _on_file_selected(path):
	get_parent().path = path
	$NewRoomDialog/NewRoom/MapPath.text = path

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
	$FileDialog.hide()


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
	Global.game_paused = false


func _on_load_game_button_pressed():
	OS.alert("Under construction.")

extends Node

onready var room_controls = $Bottombar/RoomControls

func _on_create_button_pressed():
	$NewRoomDialog.popup()

func _on_sb_pressed():
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
	$ViewportContainer/WorldViewport/World.load_map("user://server/index.map")


func _on_connect_button_pressed():
	$ConnectDialog.popup()
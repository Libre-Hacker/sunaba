extends Node


func _ready():
	$TopBar/Menubar/MenuButtonGame.get_popup().connect("id_pressed", self, "_game_menu")
	$TopBar/Menubar/MenuButtonTools.get_popup().connect("id_pressed", self, "_tools_menu")

func _game_menu(id):
	if id == 0:
		print(id)
	elif id == 1:
		$NewRoomDialog.popup()

func _tools_menu(id):
	if id == 0:
		get_tree().change_scene("res://src/tools/editor.tscn")
	elif id == 1:
		$SettingsDialog.popup()


func _on_file_button_pressed():
	$NativeDialogOpenFile.show()

func _on_file_selected(path):
	get_parent().path = path
	$NewRoomDialog/MapPath.text = path

func _on_NativeDialogOpenFile_files_selected(files: PoolStringArray):
	var path = files[0]
	if path != null:
		_on_file_selected(path)

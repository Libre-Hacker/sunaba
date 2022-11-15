extends WindowDialog


func _on_file_selected(path):
	$Tabs/TabContainer/Map/VBoxContainer/Path.text = path

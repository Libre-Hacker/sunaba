extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$NativeNotification1.send()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_native_file_dialog():
	$NativeFileDialog.show()


func _on_native_file_dialog_file_selected(path):
	get_parent().OnFileSelected(path)

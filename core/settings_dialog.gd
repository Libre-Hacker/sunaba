extends Window

var settings = {
	# Theme
	1 : "res://assets/ui/2kui/2kui.tres",
	# Fullscreen Mode
	2 : false
}



# Theming-related variables
@export var gui : NodePath
# Themes

# Graphics-related variables
@onready var theme_dropdown = $Panel/TabBar/TabContainer/UI/VBoxContainer/ThemingOption/Label/ThemingOptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	#OS.min_window_size = Vector2(640,480)
	#var file = File.new()
	#file.open("user://config.tres", File.READ)
	#if file.file_exists("user://config.tres"):
		#settings = file.get_as_text()
		#file.close()
	
	var dir = DirAccess.open("res://themes")
	
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif (not file.ends_with(".import")) and file.ends_with(".tres") and !file == "Default.tres":
			
			var theme_name = file.left(-5)
			theme_dropdown.add_item(theme_name)
		elif file.ends_with(".tres.remap") and !file == "Default.tres.remap":
			var theme_name = file.left(-11)
			theme_dropdown.add_item(theme_name)
	
	dir.list_dir_end()
		#change_theme(load(settings[1]))
	#else:
	change_theme(load("res://themes/Default.tres"))

func _input(_event):
	if Input.is_key_pressed(KEY_F11):
		var fullscreen = ProjectSettings.get_setting("display/window/size/mode")
		
		if fullscreen != 4:
			ProjectSettings.set_setting("display/window/size/mode", 4)
		else:
			ProjectSettings.set_setting("display/window/size/mode", 0)

func change_theme(_theme):
	theme = _theme
	get_node(gui).theme = _theme
	ThemeManager.theme = _theme
	#save()

func _on_theme_selected(index):
	print(index)
	var theme_path = "res://themes/" + theme_dropdown.get_item_text(index) + ".tres"
	var theme_res = load(theme_path)
	change_theme(theme_res)


func _on_close_requested():
	hide()

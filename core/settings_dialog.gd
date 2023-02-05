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
var carbon_dark = preload("res://assets/ui/carbon_ui/dark.tres")
var carbon_light = preload("res://assets/ui/carbon_ui/carbon_ui.tres")
var two_k_ui = preload("res://assets/ui/2kui/2kui.tres")
var libadwaita = preload("res://assets/ui/godwaita/theme.tres")
var raygui = preload("res://assets/ui/RayTheme/Default/RayGui.tres")
var sleek = preload("res://assets/ui/sl33k/sl33k.tres")
var three_point_one = preload("res://assets/ui/classic311/Classic311.tres")

# Graphics-related variables


# Called when the node enters the scene tree for the first time.
func _ready():
	#OS.min_window_size = Vector2(640,480)
	#var file = File.new()
	#file.open("user://config.tres", File.READ)
	#if file.file_exists("user://config.tres"):
		#settings = file.get_as_text()
		#file.close()
	
		#change_theme(load(settings[1]))
	#else:
	change_theme(two_k_ui)

func _input(_event):
	if Input.is_key_pressed(KEY_F11):
		#if !OS.window_fullscreen:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#else:
		#	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		pass#save()

func change_theme(_theme):
	theme = _theme
	get_node(gui).theme = _theme
	ThemeManager.theme = _theme
	#save()



func _on_theme_selected(index):
	print(index)
	if index == 0:
		settings[1] = "res://assets/ui/2kui/2kui.tres"
		change_theme(two_k_ui)
	elif index == 1:
		settings[1] = "res://assets/ui/carbon_ui/carbon_ui.tres"
		change_theme(carbon_light)
	elif index == 2:
		settings[1] = "res://assets/ui/carbon_ui/dark.tres"
		change_theme(carbon_dark)
	elif index == 3:
		settings[1] = "res://assets/ui/sl33k/sl33k.tres"
		change_theme(sleek)
	elif index == 4:
		settings[1] = "res://assets/ui/godwaita/theme.tres"
		change_theme(libadwaita)
	elif index == 5:
		settings[1] = "res://assets/ui/RayTheme/Default/RayGui.tres"
		change_theme(raygui)
	elif index == 6:
		settings[1] = "res://assets/ui/classic311/Classic311.tres"
		change_theme(three_point_one)


func _on_close_requested():
	hide()

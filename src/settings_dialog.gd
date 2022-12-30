extends WindowDialog

var settings = {
	# Theme
	1 : "res://assets/ui/sl33k/sl33k.tres",
	# Fullscreen Mode
	2 : false
}



# Theming-related variables
export var gui : NodePath
# Themes
var carbon_dark = preload("res://assets/ui/carbon_ui/dark.tres")
var carbon_light = preload("res://assets/ui/carbon_ui/carbon_ui.tres")
var two_k_ui = preload("res://assets/ui/2kui/2kui.tres")
var libadwaita = preload("res://assets/ui/godwaita/theme.tres")
var raygui = preload("res://assets/ui/RayTheme/Default/RayGui.tres")
var sleek = preload("res://assets/ui/sl33k/sl33k.tres")
var three_point_one = preload("res://assets/ui/classic311/Classic311.tres")

# Graphics-related variables
onready var fullscreen_toggle = $Tabs/TabContainer/Graphics/VBoxContainer/FullscreenToggle


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.min_window_size = Vector2(640,480)
	var file = File.new()
	file.open("user://config.tres", File.READ)
	#if file.file_exists("user://config.tres"):
		#settings = file.get_as_text()
		#file.close()
	
		#change_theme(load(settings[1]))
	#else:
	change_theme(sleek)

func _input(_event):
	if Input.is_key_pressed(KEY_F11):
		OS.window_fullscreen = !OS.window_fullscreen
		save()

func change_theme(theme):
	theme = theme
	get_node(gui).theme = theme
	ThemeManager.theme = theme
	save()



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


func _on_fullscreen_toggled(_button_pressed):
	#OS.window_fullscreen = button_pressed
	#save()
	pass

func save():
	var file = File.new()
	file.open("user://config.tres", File.WRITE)
	file.store_string(var2str(settings))
	file.close()

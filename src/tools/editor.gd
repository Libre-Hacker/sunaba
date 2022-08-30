extends Spatial
onready var voxel_tools = $Editor/VoxelTools
onready var menu_button = $Editor/Toolbar/Menubar/MenuButton
onready var editor_view = $EditorView
onready var toolbar = $Editor/Toolbar


# Called when the node enters the scene tree for the first time.
func _ready():
	voxel_tools.hide()
	menu_button.get_popup().connect("id_pressed", self, "_on_item_pressed")
	$Editor/Toolbar/Menubar/HelpMenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed_help")
	toolbar.show()

func _on_item_pressed(id):
	var item_name = menu_button.get_popup().get_item_text(id)
	if id == 0:
		#$Editor/FileDialog.popup()
		$Editor/FileDialog.popup()
	elif id == 1:
		#$Editor/SaveDialog.popup()
		pass
	elif id == 2:
		$Editor/SaveDialog.popup()
	elif id == 3:
		get_tree().change_scene("res://src/main.tscn")
	print(item_name + ' pressed')

func _on_item_pressed_help(id):
	if id == 0:
		$AboutDialog.show()

func show_voxel_tools():
	voxel_tools.show()
	editor_view.block_edit_mode = true

func _object_mode():
	editor_view.block_edit_mode = false
	voxel_tools.hide()

func show_toolbar():
	toolbar.show()

extends Spatial
onready var voxel_tools = $Editor/VoxelTools
onready var menu_button = $Editor/Toolbar/Menubar/MenuButton
onready var editor_view = $EditorView
onready var script_editor = $Editor/ScriptEditor
onready var toolbar = $Editor/Toolbar
onready var tb_shadow = $Editor/TextureRect3


# Called when the node enters the scene tree for the first time.
func _ready():
	voxel_tools.hide()
	menu_button.get_popup().connect("id_pressed", self, "_on_item_pressed")
	$Editor/Toolbar/Menubar/HelpMenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed_help")
	toolbar.show()
	tb_shadow.show()
	#$TextureRect2.show()
	script_editor.hide()

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
	print(item_name + ' pressed')

func _on_item_pressed_help(id):
	if id == 0:
		$AboutDialog.show()

func show_voxel_tools():
	voxel_tools.show()
	editor_view.block_edit_mode = true
	script_editor.hide()

func _on_ScriptButton_pressed():
	script_editor.show()
	editor_view.block_edit_mode = false
	voxel_tools.hide()
	#toolbar.hide()


func _object_mode():
	editor_view.block_edit_mode = false
	voxel_tools.hide()

func _on_3DButton_pressed():
	script_editor.hide()
	toolbar.show()
	$Editor/TextureRect2.show()


func show_toolbar():
	toolbar.show()
	tb_shadow.show()


func _stop_game():
	pass


func _create_server():
	pass # Replace with function body.


func _on_file_opened(paths):
	pass # Replace with function body.

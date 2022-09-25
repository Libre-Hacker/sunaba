extends Control

#var vm: Lua
# Declare member variables here. Examples:
# var a = 2
# var b = "text
#onready var output = $Panel/Output

class System:
	
	func printToOutput(output):
		output.add_text(output)
		output.newline()



# Called when the node enters the scene tree for the first time.
func _ready():
	$Menubar/FileMenuButton.get_popup().connect("id_pressed", self, "fmb_pressed")
	#vm = Lua.new()
	#vm.push_variant("luaPrintToOutput", "printToOutput")
	#vm.expose_function( get_node("."), "printToOutput", "print")
	#printToOutput("mintkat's Lua IDE")
	#printToOutput("(C) 2022 mintkat")
	#$Panel/Output.newline()


func fmb_pressed(id):
	if id == 0:
		$FileDialog.popup()
	elif id == 2:
		$SaveFileDialog.popup()


func _on_FileDialog_file_selected(path):
	print(path)
	var f = File.new()
	f.open(path, 1)
	$TextEdit.text = f.get_as_text()


func _on_SaveFileDialog_file_selected(path):
	var f = File.new()
	f.open(path + ".snb", File.WRITE)
	f.store_string($TextEdit.text)


func _on_Button_pressed():
	#$LuaFileDialog.popup()
	#vm.do_string($TextEdit.text)
	pass

func _on_LuaFileDialog_file_selected(path):
	if ".lua" in path:
		#vm.do_file(path)
		pass

#func printToOutput(output):
		#$Panel/Output.add_text(output)
		#$Panel/Output.newline()
		#print(output)


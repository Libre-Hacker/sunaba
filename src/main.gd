extends Node


func _ready():
	$UI/TopBar/Menubar/MenuButtonGame.get_popup().connect("id_pressed", self, "_game_menu")

func _game_menu(id):
	if id == 0:
		print(id)
	elif id == 1:
		print(id)

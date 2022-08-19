extends WindowDialog


onready var page1 = $Page1
onready var page2 = $Page2
onready var page3 = $Page3

func _ready():
	#popup()
	page1.show()
	page2.hide()
	page3.hide()


func _on_NSButton_pressed():
	get_parent().new_game()


func show_page3():
	page1.hide()
	page2.hide()
	page3.show()


#func _on_hide():
	#get_tree().quit()

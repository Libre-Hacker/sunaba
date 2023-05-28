extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bots_toggled(button_pressed : bool):
	Global.bots_enabled = button_pressed


func _on_bot_amount_changed(value):
	Global.bot_amount = value

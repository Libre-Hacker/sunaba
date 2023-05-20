extends SpringArm3D

@export var mouse_sensitivity : float = .1

func _input(event):
	if event is InputEventMouseMotion and (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		var mouse_axis : Vector2 = event.relative
		rotation.y -= mouse_axis.x * mouse_sensitivity * .01
		rotation.x = clamp(rotation.x - mouse_axis.y * mouse_sensitivity * .01, -1.5, 1.5)

func _process(delta):
	rotation.z = 0

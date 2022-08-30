extends SpringArm

export var mouse_sensitivity := 0.25

var is_camera_button_hold = false

func _ready():
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta):
	if Input.is_action_pressed("camera_button"):
		is_camera_button_hold = true
	else:
		is_camera_button_hold = false

func _input(event: InputEvent) -> void:
	if is_camera_button_hold:
		#print("Camera Button Hold")
		if event is InputEventMouseMotion:
			rotation_degrees.x -= event.relative.y * mouse_sensitivity
			rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
			
			rotation_degrees.y -= event.relative.x * mouse_sensitivity
			rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
		

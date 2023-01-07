extends SpringArm

export var mouse_sensitivity := 0.25

var is_camera_button_hold = false
var can : bool

func _ready():
	if !get_parent().camera_mode == 3:
		return
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(_delta):
	if !get_parent().camera_mode == 3:
		return
	if Input.is_action_pressed("camera_button"):
		is_camera_button_hold = true
	else:
		is_camera_button_hold = false

func _input(event: InputEvent) -> void:
	if !get_parent().camera_mode == 3:
		return
	if !Input.is_action_pressed("jump") and !Input.is_action_pressed("move_backward") and !Input.is_action_pressed("move_forward") and !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right") and OS.get_name() == "Android":
		if event is InputEventMouseMotion:
			rotation_degrees.x -= event.relative.y * mouse_sensitivity
			rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
			
			rotation_degrees.y -= event.relative.x * mouse_sensitivity
			rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
	if is_camera_button_hold:
		#print("Camera Button Hold")
		if event is InputEventMouseMotion:
			rotation_degrees.x -= event.relative.y * mouse_sensitivity
			rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
			
			rotation_degrees.y -= event.relative.x * mouse_sensitivity
			rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
		
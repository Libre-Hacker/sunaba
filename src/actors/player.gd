extends KinematicBody

export var speed = 3.5
export var jump_strength := 10.0
export var gravity := 25.0

var _velocity = Vector3.ZERO
var _snap_vector = Vector3.DOWN
var motion = Vector3.ZERO

var puppet_pos = Vector3()
var puppet_vel = Vector3()
var puppet_rot = Vector3()

onready var spring_arm = $SpringArm
onready var camera = $SpringArm/Camera
onready var _model := $Myoko as Spatial
onready var parent = get_parent()
onready var ntr = $NetworkTickRate
onready var movetween = $MovementTween

func _ready():
	#camera.current = is_network_master()
	pass
	#global_transform.origin = Vector3(0, 5, 0)

func _physics_process(delta: float) -> void:
	#if is_network_master():
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta
	
	var just_landed = is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_just_pressed("jump")
	if is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif just_landed:
		_snap_vector = Vector3.DOWN
	#else:
		#global_transform.origin = puppet_pos
		#_velocity.x = puppet_vel.x
		#_velocity.z = puppet_vel.z
		#rotation.y = puppet_rot.y
	#if !movetween.is_active():
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle()
	#if !is_network_master():
		#if !movement_tween.is_active():
			#_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	
func _process(_delta: float) -> void:
	#if is_network_master():
	spring_arm.translation = translation
	spring_arm.translation.y = translation.y + 0.7

puppet func update_state(p_pos, p_vel, p_rot):
	puppet_pos = p_pos
	puppet_vel = p_vel
	puppet_rot = p_rot
	
	movetween.interpolate_property(self, "global_transform", global_transform, Transform(global_transform.basis, puppet_pos), 0.1)
	movetween.start()


func _on_timeout():
	pass
	#if is_network_master():
		#rpc_unreliable("update_state")
		#rset_unreliable(puppet_pos, global_transform)
		#rset_unreliable(puppet_vel, _velocity)
		#rset_unreliable(puppet_rot, Vector3(rotation.x, rotation.y, rotation.z))
		
		
		#rpc_unreliable("update_state", global_transform.origin, _velocity, Vector2(rotation.x, rotation.y))

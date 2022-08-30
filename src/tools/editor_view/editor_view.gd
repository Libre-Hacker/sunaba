extends KinematicBody

## Constants
const voxel_size := 0.5

## Exported Variables
export(float, 0.0, 100.0) var speed := 12.0
export(float, 0.0, 100.0) var jump := 1.0
export(float, -100.0, 100.0) var gravity := -9.81
export(float, 0.0, 10.0) var camera_sensitivity := 5.0
export(NodePath) var world_path setget set_world_path

## Private Variables
var _world : VoxelMesh = null
var _block_id := 0
var _cursor_normal := Vector3()
var _cursor_position := Vector3()
var edit_mode = true
var block_edit_mode = false
var block_create_mode = true
var block_remove_mode = false
var block_pos = null
var block_list = ItemList
var block_num := 0


## OnReady Variables
onready var camera : Camera = get_node("Camera")
onready var raycast : RayCast = get_node("Camera/RayCast")
onready var cursor : MeshInstance = get_node("Cursor")
onready var block : MeshInstance = get_node("Camera/Block")

var list = ""


export var blocks := {}

func add_block_to_list(unique_id: int, new_type : int, new_pos : Vector3):
	var new_block = block_data.new(new_type, new_pos)
	blocks[unique_id] = {type = new_type, position = new_pos}
	print(blocks[unique_id])
	print(blocks[unique_id].type)
	#emit_changed()


## Built-In Virtual Methods
func _ready() -> void:
	set_world_path(world_path)
	cursor.visible = false


func _unhandled_input(event : InputEvent) -> void:
	
	if not camera.current:
		return
	
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE and not event.is_pressed():
			if block_edit_mode:
				block_edit_mode = false
			else:
				block_edit_mode = true
			
	
	if !block_edit_mode:
		return
	
	
	
	if event is InputEventMouseButton:
		if not event.pressed:
			if is_instance_valid(_world) and raycast.is_colliding():
				match event.button_index:
					BUTTON_LEFT:
						if block_create_mode:
							add_block()
						elif block_remove_mode:
							remove_block()
				
	_update_cursor_position()

func _physics_process(delta):
	if !block_edit_mode:
		return
	if !camera.current:
		return
	
	#if Input.is_action_pressed("action_button_1"):
		#if block_create_mode:
			#add_block()
		#elif block_remove_mode:
			#remove_block()


func add_block():
	var target = Voxel.world_to_grid(_cursor_position)
	target += _cursor_normal
	_world.set_voxel(target, _block_id)
	_world.update_mesh()
	#var new_block = block_data.new(_block_id, target)
	#terrain_data.add_block(block_num, _block_id, target)
	block_num = block_num + 1
	add_block_to_list(block_num, _block_id, target)
	#print(new_block.to_string())

func add_block_using_pos(pos : Vector3):
	_world.set_voxel(pos, _block_id)
	_world.update_mesh()
	#var new_block = block_data.new(_block_id, target)
	#terrain_data.add_block(block_num, _block_id, target)
	block_num = block_num + 1
	add_block_to_list(block_num, _block_id, pos)
	#print(new_block.to_string())

func remove_block():
	var target = Voxel.world_to_grid(_cursor_position)
	_world.erase_voxel(target)
	_world.update_mesh()
	block_num = block_num + 1
	add_block_to_list(block_num, -1, target)

func remove_block_using_pos(pos : Vector3):
	_world.erase_voxel(pos)
	_world.update_mesh()
	block_num = block_num + 1
	add_block_to_list(block_num, -1, pos)

func _process(delta : float) -> void:
	if !block_edit_mode:
		block.visible = false
		cursor.visible = false
		return
	if !camera.current:
		block.visible = false
		cursor.visible = false
		return
	block.visible = true
	cursor.visible = true
	if not camera.current or Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	#var direction := Vector3()
	#if Input.is_action_pressed("move_forward"):
	#	direction += Vector3.BACK
	#if Input.is_action_pressed("move_back"):
	#	direction += Vector3.FORWARD
	#if Input.is_action_pressed("move_right"):
	#	direction += Vector3.RIGHT
	#if Input.is_action_pressed("move_left"):
	#	direction += Vector3.LEFT
	
	#if Input.is_action_just_pressed("jump"):
	#	translate(Vector3.UP * jump)
	
	#var velocity := Vector3()
	#velocity += -camera.global_transform.basis.z * direction.z
	#velocity += camera.global_transform.basis.x * direction.x
	#velocity.y = 0
	#velocity = (velocity * speed) + Vector3(0, gravity, 0)
	
	#move_and_collide(velocity * delta)
	_update_cursor_position()



## Public Methods
func set_world_path(path : NodePath) -> void:
	if path.is_empty():
		world_path = null
		_world = null
	else:
		world_path = path
		if is_inside_tree():
			var node = get_node(path)
			if node is VoxelMesh:
				_world = node
				_update_block()



## Private Methods
func _update_cursor_position() -> void:
	var pos := raycast.get_collision_point()
	_cursor_normal = raycast.get_collision_normal().round()
	_cursor_position = pos - _cursor_normal * (voxel_size / 2)
	
	cursor.visible = raycast.is_colliding()
	if cursor.visible:
		var tran = Voxel.world_to_snapped(_cursor_position)
		tran += Vector3.ONE * (voxel_size / 2)
		tran = to_local(tran)
		cursor.translation = tran


func _update_block() -> void:
	if !block_edit_mode:
		return
	
	if is_instance_valid(_world) and is_instance_valid(_world.voxel_set):
		var vt := VoxelTool.new()
		
		vt.begin(_world.voxel_set, true)
		for face in Voxel.Faces:
			vt.add_face(
					_world.voxel_set.get_voxel(_block_id),
					face, -Vector3.ONE / 2)
		block.mesh = vt.commit()


func _block_create_mode_on():
	block_edit_mode = true
	block_create_mode = true
	block_remove_mode = false


func _block_remove_mode_on():
	block_edit_mode = true
	block_create_mode = false
	block_remove_mode = true


func _select_block_0():
	_block_id = 0
	_update_block()


func _select_block_1():
	_block_id = 1
	_update_block()


func _select_block_2():
	_block_id = 2
	_update_block()


func _select_block_3():
	_block_id = 3
	_update_block()


func _select_block_4():
	_block_id = 4
	_update_block()


func _select_block_5():
	_block_id = 5
	_update_block()


func _select_block_6():
	_block_id = 6
	_update_block()


func _select_block_7():
	_block_id = 7
	_update_block()


func _select_block_8():
	_block_id = 8
	_update_block()


func _select_block_9():
	_block_id = 9
	_update_block()


func _select_block_10():
	_block_id = 10
	_update_block()


func _select_block_11():
	_block_id = 11
	_update_block()


func _select_block_12():
	_block_id = 12
	_update_block()


func _select_block_13():
	_block_id = 13
	_update_block()


func _select_block_14():
	_block_id = 14
	_update_block()


func _select_block_15():
	_block_id = 15
	_update_block()


func _select_block_16():
	_block_id = 16
	_update_block()


func _select_block_17():
	_block_id = 17
	_update_block()


func _select_block_18():
	_block_id = 18
	_update_block()


func _select_block_19():
	_block_id = 19
	_update_block()


func _select_block_20():
	_block_id = 20
	_update_block()

func _on_file_saved(path):
	var file = File.new()
	file.open(path + ".sbvx", File.WRITE)
	file.store_string(var2str(blocks))
	file.close()
	


func _on_file_opened(path):
	var file = File.new()
	file.open(path, File.READ)
	var sbg_text = file.get_as_text()
	var sbg = str2var(sbg_text)
	print(sbg)
	for id in sbg:
		print(id)
		var sbg_item = sbg[id]
		print(sbg_item)
		if !sbg_item.type == -1:
			_block_id = sbg_item.type
			_update_block()
			block_pos = sbg_item.position
			add_block_using_pos(block_pos)
		else:
			remove_block_using_pos(sbg_item.position)
	file.close()


func _on_Panel_hide():
	pass # Replace with function body.


func _on_VoxelTools_about_to_show():
	block_edit_mode = true


func _on_VoxelTools_popup_hide():
	block_edit_mode = false
	block_create_mode = false
	block_remove_mode = false

class block_data:
	var type : int
	var position : Vector3
	
	func _init(_type : int, _position : Vector3):
		type = _type
		position = _position
	
	func to_string():
		return "type: %d position: %s" % [type, position]



func _on_FileDialog_file_selected(path):
	pass # Replace with function body.

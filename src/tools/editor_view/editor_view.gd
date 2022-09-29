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
	blocks[unique_id] = {type = new_type, position = new_pos}
	#print(blocks[unique_id])
	#print(blocks[unique_id].type)
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

func select_block(num):
	_block_id = num
	_update_block()


func _on_file_saved(path):
	var file = File.new()
	if ".snb" in path:
		file.open(path, File.WRITE)
	else:
		file.open(path + ".snb", File.WRITE)
	var sbg = { props = get_parent().props, terrain = blocks }
	file.store_string(var2str(sbg))
	file.close()
	get_parent().path == path


func _on_file_opened(path):
	var file = File.new()
	file.open(path, File.READ)
	var sbg_text = file.get_as_text()
	var sbg = str2var(sbg_text)
	#var terrain = sbg.terrain
	#print(sbg)
	#print(sbg.terrain)
	get_parent().load_props(sbg.props)
	for id in sbg.terrain:
		#print(id)
		var sbg_item = sbg.terrain[id]
		#print(sbg_item)
		if !sbg_item.type == -1:
			_block_id = sbg_item.type
			_update_block()
			block_pos = sbg_item.position
			add_block_using_pos(block_pos)
		else:
			remove_block_using_pos(sbg_item.position)
	
	file.close()
	get_parent().path == path


func _on_Panel_hide():
	pass # Replace with function body.


func _on_VoxelTools_about_to_show():
	block_edit_mode = true


func _on_VoxelTools_popup_hide():
	block_edit_mode = false
	block_create_mode = false
	block_remove_mode = false


func _on_file_selected(files: PoolStringArray):
	var path = files[0]
	_on_file_opened(path)

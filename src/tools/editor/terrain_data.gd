class_name TerrainData
extends Resource

export var blocks := {}

func add_block(unique_id: int, new_type : int, new_pos : Vector3):
	var new_block = block_data.new(new_type, new_pos)
	blocks[unique_id] = new_block
	emit_changed()
	
func remove_block(unique_id: int, new_type : int, new_pos : Vector3):
	var new_block = block_data.new(new_type, new_pos)
	
	if blocks[unique_id] <= 0:
		blocks.erase(unique_id)

class block_data:
	var type : int
	var position : Vector3
	
	func _init(_type : int, _position : Vector3):
		type = _type
		position = _position
	
	func to_string():
		return "type: %d position: %s" % [type, position]

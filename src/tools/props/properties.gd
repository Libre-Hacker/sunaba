extends WindowDialog

var pos : Vector3
var pos_x : int
var pos_y :int
var pos_z :int


func _on_x_value_changed(value):
	get_parent().translation.x = value
	get_parent().update_transform()


func _on_y_value_changed(value):
	get_parent().translation.y = value
	get_parent().update_transform()


func _on_z_value_changed(value):
	get_parent().translation.z = value
	get_parent().update_transform()


func _on_rot_x_value_changed(value):
	get_parent().rotation.x = value
	#get_parent().update_transform()


func _on_rot_y_value_changed(value):
	get_parent().rotation.y = value
	#get_parent().update_transform()


func _on_rot_z_value_changed(value):
	get_parent().rotation.z = value
	#get_parent().update_transform()


func _on_size_x_value_changed(value):
	get_parent().scale.x = value
	#get_parent().update_transform()


func _on_size_y_value_changed(value):
	get_parent().scale.y = value
	#get_parent().update_transform()


func _on_size_z_value_changed(value):
	get_parent().scale.z = value
	#get_parent().update_transform()

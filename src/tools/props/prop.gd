extends Spatial

var prop_id : int

func initialize():
	$Properties/Tabs/TabContainer/Transform/Control/HBoxContainer/x.value == translation.x
	$Properties/Tabs/TabContainer/Transform/Control/HBoxContainer/y.value == translation.y
	$Properties/Tabs/TabContainer/Transform/Control/HBoxContainer/z.value == translation.z

func edit_prop():
	$Properties.popup()

func update_transform():
	get_parent().update_prop_transform(prop_id, translation, rotation, scale)

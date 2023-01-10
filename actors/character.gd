extends Node3D


var skin = null


@onready var body = $metarig/Skeleton3D/BaseCharacter
@onready var headwear = $metarig/Skeleton3D/HeadwearAttachment


func hide_meshes():
	body.hide()
	headwear.hide()


func show_meshes():
	body.show()
	headwear.show()

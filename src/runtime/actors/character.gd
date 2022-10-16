extends Spatial


var skin = null


onready var body = $metarig/Skeleton/BaseCharacter
onready var headwear = $metarig/Skeleton/HeadwearAttachment


func hide_meshes():
	body.hide()
	headwear.hide()


func show_meshes():
	body.show()
	headwear.show()

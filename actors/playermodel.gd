extends Node3D

var face_material = 1
var torso_material = 2
var pants_material = 5
var arms_material = 3
var hands_material = 4
var foot_material = 6
var head_material = 0

@onready var base_mesh = $"Akari/GeneralSkeleton/Base Mesh"
@onready var hw_attachment = $Akari/GeneralSkeleton/Hair

func _process(delta):
	change_headwear(Global.headwear)
	change_texture(head_material, "res://addons/toonroid/textures/" + Global.skinColor + ".png")
	change_face_texture(Global.faceTexture)
	change_texture(torso_material, get_clothing_texture(Global.torsoTexture))
	change_texture(arms_material, get_clothing_texture(Global.armsTexture))
	change_texture(hands_material, get_clothing_texture(Global.handsTexture))
	change_texture(pants_material, get_clothing_texture(Global.pantsTexture))
	change_texture(foot_material, get_clothing_texture(Global.shoesTexture))

func get_headwear_model(model_name : String):
	var path = "res://addons/toonroid/headwear/" + model_name + ".tscn"
	return path

func get_face_texture(texture_name : String):
	var path = "res://addons/toonroid/textures/face/" + Global.skinColor + "/" + texture_name + ".png"
	return path

func get_clothing_texture(texture_name : String):
	var path = "res://addons/toonroid/textures/clothes/" + Global.skinColor + "/" + texture_name + ".png"
	if texture_name == "skin":
		path = "res://addons/toonroid/textures/" + Global.skinColor + ".png"
	return path

func change_texture(material, texture_path):
	var texture = load(texture_path)
	base_mesh.get_surface_override_material(material).albedo_texture = texture


func change_face_texture(texture):
	change_texture(face_material, get_face_texture(texture))

func change_headwear(headwear_name):
	if hw_attachment.get_child_count() > 0:
		if hw_attachment.get_child(0) != null:
			hw_attachment.get_child(0).queue_free()
	var hw = load(get_headwear_model(headwear_name)).instantiate()
	hw_attachment.add_child(hw)
	hw.position.y = 0.274
	hw.position.z = 0.009

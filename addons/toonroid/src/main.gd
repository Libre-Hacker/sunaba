extends Control

var face_material = 1
var torso_material = 2
var pants_material = 5
var arms_material = 3
var hands_material = 4
var foot_material = 6
var head_material = 0

var headwear : String = "black_long_hair"
var skin_color : String = "pale"
var face_texture : String = "face_lightblue"
var torso_texture : String = "lunar_blue"
var arms_texture : String = "lunar_blue"
var hands_texture : String = "lunar_blue"
var pants_texture : String = "lunar_blue"
var shoes_texture : String = "lunar_blue"

@onready var base_mesh = $"SubViewportContainer/SubViewport/basemodel/Akari/GeneralSkeleton/Base Mesh"

@onready var skin_tree = $Panel/TabBar/TabContainer/Skin/Tree
@onready var hw_tree = $Panel/TabBar/TabContainer/Headwear/Tree
@onready var face_tree = $Panel/TabBar/TabContainer/Face/Tree
@onready var torso_tree = $Panel/TabBar/TabContainer/Torso/Tree
@onready var arms_tree = $Panel/TabBar/TabContainer/Arms/Tree
@onready var hands_tree = $Panel/TabBar/TabContainer/Hands/Tree
@onready var pants_tree = $Panel/TabBar/TabContainer/Pants/Tree
@onready var shoes_tree = $Panel/TabBar/TabContainer/Shoes/Tree
@onready var hw_attachment = $SubViewportContainer/SubViewport/basemodel/Akari/GeneralSkeleton/HeadwearAttachment

func _ready():
	change_headwear(headwear)
	change_texture(head_material, "res://addons/toonroid/textures/" + skin_color + ".png")
	change_face_texture(Global.faceTexture)
	change_texture(torso_material, get_clothing_texture(torso_texture))
	change_texture(arms_material, get_clothing_texture(arms_texture))
	change_texture(hands_material, get_clothing_texture(hands_texture))
	change_texture(pants_material, get_clothing_texture(pants_texture))
	change_texture(foot_material, get_clothing_texture(shoes_texture))
	
	create_item(skin_tree, "skin")
	create_item(skin_tree, "pale")
	create_item(skin_tree, "brown")
	
	create_item(face_tree, "face")
	#create_item(face_tree, "blue")
	#create_item(face_tree, "cyan")
	#create_item(face_tree, "green")
	#create_item(face_tree, "grey")
	#create_item(face_tree, "orange")
	#create_item(face_tree, "pink")
	#create_item(face_tree, "purple")
	#create_item(face_tree, "red")
	#create_item(face_tree, "yellow")
	
	create_item(torso_tree, "torso")
	create_item(arms_tree, "arms")
	create_item(arms_tree, "skin")
	create_item(hands_tree, "hands")
	create_item(hands_tree, "skin")
	create_item(pants_tree, "pants")
	create_item(shoes_tree, "shoes")
	add_headwear("headwear")
	
	var dir_faces = DirAccess.open("res://addons/toonroid/textures/face/pale/")
	
	dir_faces.list_dir_begin()
	
	while true:
		var file = dir_faces.get_next()
		if file == "":
			break
		elif OS.has_feature("editor") and ((not file.ends_with(".import")) and file.ends_with(".png")):
			create_item(face_tree, file.left(-7))
		elif (!OS.has_feature("editor")) and (file.ends_with(".png.import")):
			create_item(face_tree, file.left(-14))
	
	dir_faces.list_dir_end()
	
	#add_headwear("akari")
	#add_headwear("himiko")
	#add_headwear("black_long_hair")
	
	var dir = DirAccess.open("res://addons/toonroid/headwear/")
	
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif  OS.has_feature("editor") and (file.ends_with(".tscn")):
			add_headwear(file.left(-5))
		elif  !OS.has_feature("editor") and (file.ends_with(".tscn.remap")):
			add_headwear(file.left(-11))
	
	dir.list_dir_end()
	
	
	var dir_clothes = DirAccess.open("res://addons/toonroid/textures/clothes/pale/")
	
	dir_clothes.list_dir_begin()
	
	while true:
		var file = dir_clothes.get_next()
		if file == "":
			break
		elif OS.has_feature("editor") and ((not file.ends_with(".import")) and file.ends_with(".png")):
			add_item(file.left(-4))
		elif (!OS.has_feature("editor")) and (file.ends_with(".png.import")):
			add_item(file.left(-11))
	
	dir_clothes.list_dir_end()
	
	#add_item("himiko")
	#add_item("bikini")
	#add_item("akari")
	#add_item("lunar_blue")
	#add_item("lunar_cyan")
	#add_item("lunar_green")
	#add_item("lunar_grey")
	#add_item("lunar_lime")
	#add_item("lunar_ling")
	#add_item("lunar_orange")
	#add_item("lunar_pink")
	#add_item("lunar_purple")
	#add_item("lunar_silver")
	

func _process(delta):
	Global.headwear = headwear
	Global.skinColor = skin_color
	Global.faceTexture = face_texture
	Global.torsoTexture = torso_texture
	Global.armsTexture = arms_texture
	Global.handsTexture = hands_texture
	Global.pantsTexture = pants_texture
	Global.shoesTexture = shoes_texture

func add_item(item : String):
	create_item(torso_tree, item)
	create_item(arms_tree, item)
	create_item(hands_tree, item)
	create_item(pants_tree, item)
	create_item(shoes_tree, item)

func add_headwear(hw : String):
	create_item(hw_tree, hw)

func create_item(tree : Tree, name : String):
	var item = tree.create_item()
	item.set_text(0, name)

func get_headwear_model(model_name : String):
	var path = "res://addons/toonroid/headwear/" + model_name + ".tscn"
	return path

func get_face_texture(texture_name : String):
	var path = "res://addons/toonroid/textures/face/" + skin_color + "/" + texture_name + ".png"
	return path

func get_clothing_texture(texture_name : String):
	var path = "res://addons/toonroid/textures/clothes/" + skin_color + "/" + texture_name + ".png"
	if texture_name == "skin":
		path = "res://addons/toonroid/textures/" + skin_color + ".png"
	return path

func change_texture(material, texture_path):
	var texture = load(texture_path)
	base_mesh.get_surface_override_material(material).albedo_texture = texture


func change_face_texture(name):
	face_texture = name + "_xl"
	change_texture(face_material, get_face_texture(face_texture))



func _on_face_tree_item_selected():
	var item = face_tree.get_selected().get_text(0)
	if item != "face":
		change_face_texture(item)


func _on_torso_tree_item_selected():
	var item = torso_tree.get_selected().get_text(0)
	if item != "torso":
		torso_texture = item
		change_texture(torso_material, get_clothing_texture(torso_texture))


func _on_arms_tree_item_selected():
	var item = arms_tree.get_selected().get_text(0)
	if item != "torso":
		arms_texture = item
		change_texture(arms_material, get_clothing_texture(arms_texture))


func _on_hands_tree_item_selected():
	var item = hands_tree.get_selected().get_text(0)
	if item != "hands":
		hands_texture = item
		change_texture(hands_material, get_clothing_texture(hands_texture))


func _on_pants_tree_item_selected():
	var item = pants_tree.get_selected().get_text(0)
	if item != "pants":
		pants_texture = item
		change_texture(pants_material, get_clothing_texture(pants_texture))


func _on_shoes_tree_item_selected():
	var item = shoes_tree.get_selected().get_text(0)
	if item != "pants":
		shoes_texture = item
		change_texture(foot_material, get_clothing_texture(shoes_texture))


func _on_skin_tree_item_selected():
	var item = skin_tree.get_selected().get_text(0)
	if item != "skin":
		skin_color = item
		change_texture(head_material, "res://addons/toonroid/textures/" + skin_color + ".png")
		change_texture(face_material, get_face_texture(face_texture))
		change_texture(torso_material, get_clothing_texture(torso_texture))
		change_texture(arms_material, get_clothing_texture(arms_texture))
		change_texture(hands_material, get_clothing_texture(hands_texture))
		change_texture(pants_material, get_clothing_texture(pants_texture))
		

func change_headwear(headwear_name):
	if hw_attachment.get_child_count() > 0:
		if hw_attachment.get_child(0) != null:
			hw_attachment.get_child(0).queue_free()
	var hw = load(get_headwear_model(headwear_name)).instantiate()
	hw_attachment.add_child(hw)
	hw.position.y = 0.274
	hw.position.z = 0.009


func _on_headwear_tree_item_selected():
	var item = hw_tree.get_selected().get_text(0)
	if item != "headwear":
		headwear = item
		change_headwear(item)

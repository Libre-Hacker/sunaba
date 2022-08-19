extends Spatial

var player = preload("res://src/actors/player.tscn")

onready var voxel_mesh = $VoxelMesh

func _ready():
	load_game()

func load_game():
	var file = File.new()
	file.open(GameManager.path, File.READ)
	var sbg_text = file.get_as_text()
	var sbg = str2var(sbg_text)
	for id in sbg:
		var sbg_item = sbg[id]
		voxel_mesh.set_voxel(sbg_item.position, sbg_item.type)
		voxel_mesh.update_mesh()
	var player_instance = player.instance()
	add_child(player_instance)
	player_instance.global_transform.origin = Vector3(0, 1, 0)
	player_instance.name == "Myoko"

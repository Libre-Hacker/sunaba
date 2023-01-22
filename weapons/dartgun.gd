extends RigidBody3D

@export var weapon_path : String
@export var model_path : String

@export var fgd_model = {
  "path": "assets/models/handprops/dartgun.gltf",
  "scale": 28
}

var dropped = false

func _process(_delta):
	if dropped == true:
		apply_impulse(-transform.basis.z * 10, transform.basis.z)
		dropped = false

func get_weapon():
	var weapon = load(weapon_path)
	return weapon

extends RigidBody3D

var dropped = false

func _process(_delta):
	if dropped == true:
		apply_impulse(-transform.basis.z * 10, transform.basis.z)
		dropped = false

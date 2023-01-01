extends RigidBody

var dropped = false

func _process(_delta):
	if dropped == true:
		apply_impulse(transform.basis.z, -transform.basis.z * 10)
		dropped = false

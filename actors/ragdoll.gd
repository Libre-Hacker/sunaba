extends Node3D

func _ready():
	$Akari/GeneralSkeleton.physical_bones_start_simulation()


func _on_timer_timeout():
	queue_free()

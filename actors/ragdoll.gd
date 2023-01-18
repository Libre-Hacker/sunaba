extends Node3D

func _ready():
	$metarig/Skeleton3D.physical_bones_start_simulation()


func _on_timer_timeout():
	queue_free()

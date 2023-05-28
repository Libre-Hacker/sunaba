extends Node3D
@export var anim_path :NodePath
@onready var anim = get_node(anim_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("death")


func _on_animation_finished(anim_name):
	$Timer.start()


func _on_timer_timeout():
	get_parent().queue_free()

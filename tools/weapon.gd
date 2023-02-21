extends Node3D


@export var damage : int = 15
@export var spread : int = 10
@export var cooldown_time : float = 0.1
@export var max_ammo : int = 7
@export var weapon_type: String = "semi"

@export var weapon_path : String
@export var bullet_hole_path : String

func get_weapon():
	var weapon = load(weapon_path)
	return weapon

func get_bullet_hole():
	var bullet_hole = load(bullet_hole_path)
	return bullet_hole

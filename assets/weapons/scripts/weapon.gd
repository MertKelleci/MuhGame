class_name Weapon extends Resource

@export var weapon_name := "Piston"
@export var damage := 25.0
@export var range := 25.0
@export var max_ammo := 12
@export_enum("Raycast", "Projectile") var WeaponType: int
@export var weapon_position := Vector3(0.2, -0.2, -0.3)
@export var weapon_model : PackedScene
@export var projectile_model : PackedScene

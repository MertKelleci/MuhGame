class_name Weapon extends Resource

@export var weapon_name := "Pistol"
@export var damage := 25.0
@export var range := 25.0
@export var max_ammo := 12
enum WeaponTypes {RAYCAST, PROJECTILE}
@export var weapon_type: WeaponTypes
@export var projectile_speed := 35.0
@export var weapon_position := Vector3(0.2, -0.2, -0.3)
@export var weapon_model : PackedScene
@export var projectile_model : PackedScene

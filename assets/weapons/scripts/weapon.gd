class_name Weapon extends Resource

@export var weapon_name := "Pistol"
@export var damage := 25.0
@export var range := 25.0
@export var max_ammo := 12
@export var fire_rate := 2.0
enum FiringModes {SINGLE, AUTOMATIC, BURST}
@export var firing_mode := FiringModes.SINGLE
@export_range(0, 100) var accuracy : int = 100
enum WeaponTypes {RAYCAST, PROJECTILE}
@export var weapon_type: WeaponTypes
@export var pellet_count := 1
@export var spread_angle := 0.0
@export var projectile_speed := 35.0
@export var weapon_position := Vector3(0.2, -0.2, -0.3)
@export var weapon_model : PackedScene
@export var projectile_model : PackedScene

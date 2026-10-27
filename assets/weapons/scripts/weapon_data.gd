class_name WeaponData extends Resource

@export var weapon: Weapon
@export var unlocked := false
@export var ammo := 0

func equals(weapon_b: WeaponData) -> bool:
	return weapon.equals(weapon_b.weapon)

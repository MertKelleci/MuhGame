class_name AmmoPickup extends BasePickup

@export var weapon_slot := 1
@export var ammo_amount := 10

func can_pickup(player: PlayerController) -> bool:
	if weapon_slot not in Managers.weapon_manager.weapons:
		return false
	
	var weapon_data = Managers.weapon_manager.weapons[weapon_slot]
	return weapon_data.unlocked and weapon_data.ammo < weapon_data.weapon.max_ammo

func apply_pickup(player: PlayerController) -> void:
	var weapon_data = Managers.weapon_manager.weapons[weapon_slot]
	
	var missing_ammo = weapon_data.weapon.max_ammo - weapon_data.ammo
	var ammo_to_add = min(ammo_amount, missing_ammo)
	
	weapon_data.ammo += ammo_to_add
	Managers.weapon_manager.update_ammo_count()

class_name WeaponPickup extends BasePickup

@export var weapon_slot := 1
@export var weapon_resource: Weapon

func can_pickup(player: PlayerController) -> bool:
	var weapon_data = Managers.weapon_manager.weapons[weapon_slot]
	
	return not weapon_data.unlocked or weapon_data.ammo < weapon_resource.max_ammo

func apply_pickup(player: PlayerController) -> void:
	var weapon_data = Managers.weapon_manager.weapons[weapon_slot]
	
	if weapon_data.unlocked:
		weapon_data.ammo = weapon_resource.max_ammo
		
	else:
		Managers.weapon_manager.unlock_weapon(weapon_slot, weapon_data)
		Managers.weapon_manager.switch_to_slot(weapon_slot)

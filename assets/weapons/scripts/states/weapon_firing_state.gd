extends WeaponState

func _on_firing_state_state_entered() -> void:
	if not weapon_controller:
		return
	weapon_controller.fire_weapon()

func _on_firing_state_state_physics_processing(delta: float) -> void:
	if not weapon_controller:
		return
		
	if Managers.weapon_manager.get_current_ammo() <= 0:
		weapon_controller.weapon_state_chart.send_event("onEmpty")
	
	if weapon_controller.current_weapon.firing_mode == Weapon.FiringModes.AUTOMATIC:
		if Input.is_action_pressed("fire"): 
			if weapon_controller.can_fire():
				weapon_controller.fire_weapon()
		else:
			weapon_controller.weapon_state_chart.send_event("onIdle")
	else:
		weapon_controller.weapon_state_chart.send_event("onIdle")
	# weapon_controller.weapon_state_chart.send_event("onIdle")
	

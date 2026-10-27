class_name WeaponManager extends Node

@export var weapons: Dictionary[int, WeaponData] = {}
@export var player: PlayerController

var current_slot := 1
var _first_available_slot

func _ready() -> void:
	add_to_group("weapon_manager")
	
	# Add weapon input actions
	for i in range(1, 10):
		var action_name =  "weapon_"+str(i)
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
			var event = InputEventKey.new()
			event.keycode = KEY_1 + (i-1)
			InputMap.action_add_event(action_name, event)
	
	call_deferred("init_starting_weapon")

func _unhandled_input(event: InputEvent) -> void:
	for i in range(1, 10):
		if event.is_action_pressed("weapon_"+str(i)):
			switch_to_slot(i)
			
func switch_to_slot(slot: int) -> void:
	var weapon_data = weapons.get(slot)
	
	if weapon_data and weapon_data.unlocked:
		current_slot = slot
		player.weapon_controller.switch_weapon(weapon_data)
		
func use_ammo(slot: int, amount: int = 1) -> void:
	if slot in weapons:
		weapons[slot].ammo = max(0, weapons[slot].ammo - amount)
		
func unlock_weapon(slot: int, weapon_data: WeaponData) -> void:
	weapons[slot].unlocked = true
	weapons[slot].ammo = weapons[slot].weapon.max_ammo
			
func get_current_ammo() -> int:
	return weapons[current_slot].ammo

func init_starting_weapon() -> void:
	for slot in range(1, 10):
		if weapons.has(slot) and weapons[slot].unlocked:
			switch_to_slot(slot)
			return
		

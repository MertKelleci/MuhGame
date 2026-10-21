class_name WeaponController extends Node
@export var camera: Camera3D
@export var current_weapon: Weapon
@export var weapon_model_parent: Node3D
@export var weapon_state_chart: StateChart
@onready var state_chart_debugger: Control = %StateChartDebugger

var current_weapon_model: Node3D
var current_ammo: int

func _ready() -> void:
	if current_weapon:
		spawn_weapon_model()
			

func spawn_weapon_model() -> void:
	if current_weapon_model:
		current_weapon_model.queue_free()
	
	if current_weapon.weapon_model:
		current_weapon_model = current_weapon.weapon_model.instantiate()
		weapon_model_parent.add_child(current_weapon_model)
		current_weapon_model.position = current_weapon.weapon_position
		current_ammo = current_weapon.max_ammo

func can_fire() -> bool:
	return current_ammo > 0
	
func fire_weapon() -> void:
	if can_fire():
		current_ammo -= 1
		if state_chart_debugger:
			var text = "Weapon fired. Remaining ammo: %s" %current_ammo 
			state_chart_debugger.add_history_entry(text)


func _perform_hitscan() -> void:
	if not camera:
		print("Camera not assigned")
		return
	
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.global_position
	var forward = -camera.global_transform.basis.z
	var to = from + forward * current_weapon.range
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		print()

class_name WeaponController extends Node
@export var camera: Camera3D
@export var camera_effects: CameraEffects
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
		camera_effects.add_weapon_kick(1.0, 1.0, 1.0)
		if current_weapon.weapon_type == Weapon.WeaponTypes.RAYCAST:
			_perform_hitscan()
		else:
			_spawn_projectile()
			
		if state_chart_debugger:
			state_chart_debugger.add_history_entry("Weapon fired. Remaining ammo: "+str(current_ammo))


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
		state_chart_debugger.add_history_entry("Hit: "+result.collider.name+" at "+str(result.position))
		_spawn_impact_marker(result.position, result.collider)

func _spawn_projectile() -> void:
	if not current_weapon.projectile_model:
		state_chart_debugger.add_history_entry("No projectile scene assigned")
		return
	
	if not camera:
		state_chart_debugger.add_history_entry("No camera assigned")
		return
	
	var projectile =  current_weapon.projectile_model.instantiate() as Projectile
	get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = camera.global_position
	
	var forward = -camera.global_transform.basis.z
	var velocity = current_weapon.projectile_speed * forward
	state_chart_debugger.add_history_entry("Projectile forward: "+str(forward)+" \nProjectile Velocity: "+str(velocity))
	projectile.setup(velocity, current_weapon.damage)

func _spawn_impact_marker(position: Vector3, object: Node) -> void:
	var marker = MeshInstance3D.new()
	var box = BoxMesh.new()
	
	box.size = Vector3(0.1, 0.1, 0.1)
	marker.mesh = box
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	marker.set_surface_override_material(0, material)
	
	object.add_child(marker)
	marker.global_position = position
	
	get_tree().create_timer(2.0).timeout.connect(marker.queue_free)

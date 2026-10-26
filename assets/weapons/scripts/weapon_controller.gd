class_name WeaponController extends Node
@export var camera: Camera3D
@export var camera_effects: CameraEffects
@export var weapon_model_parent: Node3D
@export var weapon_state_chart: StateChart
@onready var state_chart_debugger: Control = %StateChartDebugger

var current_weapon: Weapon
var current_weapon_model: Node3D
var _fire_rate_timer := 0.0
var _can_fire_next := true	

func _ready() -> void:
	if current_weapon:
		spawn_weapon_model()
			
func _process(delta: float) -> void:
	if _fire_rate_timer > 0:
		_fire_rate_timer -= delta
		if _fire_rate_timer <= 0:
			_can_fire_next = true

func spawn_weapon_model() -> void:
	if current_weapon_model:
		current_weapon_model.queue_free()
	
	if current_weapon.weapon_model:
		current_weapon_model = current_weapon.weapon_model.instantiate()
		weapon_model_parent.add_child(current_weapon_model)
		current_weapon_model.position = current_weapon.weapon_position

func can_fire() -> bool:
	var weapon_data = Managers.weapon_manager.weapons[Managers.weapon_manager.current_slot]
	return weapon_data.ammo > 0 and _can_fire_next
	
func fire_weapon() -> void:
	if can_fire():
		Managers.weapon_manager.use_ammo(Managers.weapon_manager.current_slot)
		camera_effects.add_weapon_kick(1.0, 1.0, 1.0)
		if current_weapon.weapon_type == Weapon.WeaponTypes.RAYCAST:
			_perform_hitscan()
		else:
			_spawn_projectile()
		
		_can_fire_next = false
		_fire_rate_timer = 1.0 / current_weapon.fire_rate
		
		if state_chart_debugger:
			state_chart_debugger.add_history_entry("Weapon fired. Remaining ammo: "+str(Managers.weapon_manager.get_current_ammo()))


func _perform_hitscan() -> void:
	if not camera:
		print("Camera not assigned")
		return
	
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.global_position
	var accuracy_spread = (100 - current_weapon.accuracy) / 1000.0
	
	for i in current_weapon.pellet_count:
		var forward = -camera.global_transform.basis.z
		var accuracy_x = randf_range(-accuracy_spread, accuracy_spread)
		var accuracy_y = randf_range(-accuracy_spread, accuracy_spread)
		var direction = forward + Vector3(accuracy_x, accuracy_y, 0) * camera.global_transform.basis
		
		if current_weapon.pellet_count > 1:
			var spread_x = randf_range(-current_weapon.spread_angle, current_weapon.spread_angle)
			var spread_y = randf_range(-current_weapon.spread_angle, current_weapon.spread_angle)
			direction += Vector3(spread_x, spread_y, 0) * camera.global_transform.basis
		
		var to = from + direction * current_weapon.range
		
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
	
	var projectile = current_weapon.projectile_model.instantiate() as Projectile
	if projectile:
		# 1. Position and setup first (while in memory)
		projectile.global_position = camera.global_position - (camera.global_transform.basis.z * 1.5)
	
		var forward = -camera.global_transform.basis.z
		var accuracy_spread = (100 - current_weapon.accuracy) / 1000.0
		var accuracy_x = randf_range(-accuracy_spread, accuracy_spread)
		var accuracy_y = randf_range(-accuracy_spread, accuracy_spread)
		var direction = forward + Vector3(accuracy_x, accuracy_y, 0) * camera.global_transform.basis
		var velocity = current_weapon.projectile_speed * direction
		projectile.look_at(projectile.global_position + direction)
		projectile.setup(velocity, current_weapon.damage)
	
		# 2. Add to scene tree last
		get_tree().current_scene.add_child(projectile)

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
	
func switch_weapon(new_weapon: WeaponData) -> void:
	current_weapon = new_weapon.weapon
	
	if current_weapon_model:
		current_weapon_model.queue_free()
		
	spawn_weapon_model()
	

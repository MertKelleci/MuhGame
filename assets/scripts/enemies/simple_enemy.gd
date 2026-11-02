class_name SimpleEnemy extends BaseEnemy

@export var follow_speed := 3.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var state_chart: StateChart = $StateChart
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $"exported-model/AnimationPlayer"
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var triggerable: TriggerableComponent = $TriggerableComponent

var target: Node3D
var animation_tree_state: AnimationNodeStateMachinePlayback

func _ready() -> void:
	super._ready()
	
	target = get_tree().get_first_node_in_group("player")
	
	health_component.died.connect(_on_died)
	nav_agent.velocity_computed.connect(_on_velocity_computed)
	animation_tree_state = animation_tree["parameters/playback"]
	
	await get_tree().process_frame
	animation_tree["parameters/Idle/TimeSeek/seek_request"] = randf_range(0.0, 1.0)
	
	#if animation_player:
		#animation_player.play("Dance_Body_Roll")
		#animation_player.seek(randf_range(0.0, animation_player.current_animation_length))

func _process(delta: float) -> void:
	# 1. Calculate your dynamic value (e.g., speed from 0.0 to max_speed)
	var current_speed = velocity.length()
	var blend_input = inverse_lerp(0.0, 1.0, current_speed) # Maps speed 0 to 5 into a 0.0 to 1.0 range
	
	# 2. Feed that variable into the BlendSpace1D parameter path
	animation_tree.set("parameters/Follow/IdleChaseBlend/blend_position", blend_input)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 20.0 * delta
	
	move_and_slide()
	
func on_triggered() -> void:
	state_chart.send_event("toFollow")
	
func get_targetname() -> String:
	return triggerable.targetname if triggerable else ""

func on_trigger(player) -> void:
	state_chart.send_event("toFollow")
	
func _on_died() -> void:
	queue_free()

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z


func _on_follow_state_physics_processing(delta: float) -> void:
	if not target:
		return
	
	nav_agent.target_position = target.global_position
	
	if nav_agent.is_navigation_finished():
		nav_agent.velocity = Vector3.ZERO
		if animation_tree_state.get_current_node() != "Idle":
			animation_tree_state.travel("Idle")
		#if animation_player and animation_player.current_animation != "Dance_Body_Roll":
			#animation_player.play("Dance_Body_Roll")
			#animation_player.seek(randf_range(0.0, animation_player.current_animation_length))
		return
	
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	
	nav_agent.velocity = direction * follow_speed
	
	if animation_tree_state.get_current_node() != "Follow":
		animation_tree_state.travel("Follow")
		var current_position = animation_tree.get("parameters/Idle/playback/position")
		animation_tree.set("parameters/Follow/playback/position", current_position)
		
	#if animation_player and animation_player.current_animation != "Zombie_Walk":
		#animation_player.play("Zombie_Walk")
		#animation_player.seek(randf_range(0.0, animation_player.current_animation_length))
		
	if direction.length() > 0.01:
		var target_rotation = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, 5.0 * delta)


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		on_triggered()

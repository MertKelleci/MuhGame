class_name CameraEffects extends Camera3D
@export_category("References")
@export var player : PlayerController

@export_category("Effects")
@export var enable_tilt : bool = true
@export var enable_fall_kick : bool = true

@export_category("Kick & Recoil Settings")
@export_category("Run Tilt")
@export var run_pitch : float = 0.1
@export var run_roll : float = 0.25
@export var max_pitch : float = 1.0
@export var max_roll : float = 2.5
@export_group("Camera Kick")
@export_subgroup("Fall Kick")
@export var fall_time := 0.3

var _fall_timer := 0.0
var _fall_value := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	calculate_view_offset(delta)
	
	if Input.is_action_just_pressed("test_fall"):
		add_fall_kick(2.0)

func calculate_view_offset(delta: float) -> void:
	if not player:
		return
	
	_fall_timer -= delta
	
	var angles = Vector3.ZERO
	var offset = Vector3.ZERO
	
	if enable_tilt:
		var forward = global_transform.basis.z
		var right = global_transform.basis.x
		
		# This dot product calculates how much the player is moving in forward direction.
		# We calculate this in order to apply tilt to player camera.
		var forward_dot = player.velocity.dot(forward)
		var forward_tilt = clampf(forward_dot * deg_to_rad(run_pitch), deg_to_rad(-max_pitch), deg_to_rad(max_pitch))
		angles.x += forward_tilt
		
		var right_dot = player.velocity.dot(right)
		var side_tilt = clampf(right_dot * deg_to_rad(run_roll), deg_to_rad(-max_roll), deg_to_rad(max_roll))
		angles.z -= side_tilt
	
	if enable_fall_kick:
		var fall_ratio = max(0.0, _fall_timer/fall_time)
		var fall_kick_amount = fall_ratio * _fall_value
		angles.x -= fall_kick_amount
		offset.y -= fall_kick_amount
		
	position = offset
	rotation = angles
	
func add_fall_kick(fall_strength: float) -> void:
	_fall_value = deg_to_rad(fall_strength)
	_fall_timer = fall_time

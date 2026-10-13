class_name CameraEffects extends Camera3D
@export_category("References")
@export var player : PlayerController

@export_category("Effects")
@export var enable_tilt : bool = true
@export var enable_fall_kick : bool = true
@export var enable_damage_kick := true
@export var enable_weapon_kick := true
@export var enable_screen_shake := true
@export var enable_headbob := true
 
@export_category("Kick & Recoil Settings")
@export_category("Run Tilt")
@export var run_pitch : float = 0.1
@export var run_roll : float = 0.25
@export var max_pitch : float = 1.0
@export var max_roll : float = 2.5
@export_group("Camera Kicks")
@export_subgroup("Fall Kick")
@export var fall_time := 0.3
@export_subgroup("Damage Kick")
@export var damage_time := 0.3
@export_subgroup("Weapon Kick")
@export var weapon_decay := 0.5
@export_subgroup("Headbob")
@export_range(0.0, 0.1, 0.001) var bob_pitch := 0.05
@export_range(0.0, 0.1, 0.001) var bob_roll := 0.025
@export_range(0.0, 0.04, 0.001) var bob_up := 0.005
@export_range(3.0, 8.0, 0.1) var bob_frequency := 6.0

var _fall_timer := 0.0
var _fall_value := 0.0

var _damage_pitch := 0.0
var _damage_roll := 0.0
var _damage_timer := 0.0

var _weapon_kick_angles := Vector3.ZERO

var _screen_shake_tween : Tween
const _MIN_SCREEN_SHAKE := 0.05
const _MAX_SCREEN_SHAKE := 0.5

var _step_timer := 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	calculate_view_offset(delta)
	
	if Input.is_action_just_pressed("test_fall"):
		add_fall_kick(2.0)

func calculate_view_offset(delta: float) -> void:
	if not player:
		return
	
	_fall_timer -= delta
	_damage_timer -= delta
	
	var speed = Vector2(player.velocity.x, player.velocity.z).length()
	if speed > 0.1 and player.is_on_floor():
		_step_timer += delta * (speed/bob_frequency)
		_step_timer = fmod(_step_timer, 1.0)
	else:
		_step_timer = 0.0
	var bob_sin = sin(_step_timer*2.0*PI) * 0.5 # 0.5 reduces the magnitude of the bob
	
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
		
	if enable_damage_kick:
		var damage_ratio = max(0.0, _damage_timer/damage_time)
		# damage_ratio = ease(damage_ratio, -2) # If you want the effect to be over time
		angles.x += damage_ratio * _damage_pitch
		angles.z += damage_ratio * _damage_roll
		
	if enable_weapon_kick:
		_weapon_kick_angles = _weapon_kick_angles.move_toward(Vector3.ZERO, weapon_decay*delta)
		angles += _weapon_kick_angles
	
	if enable_headbob:
		angles.x -= bob_sin * deg_to_rad(bob_pitch) * speed
		angles.z -= bob_sin * deg_to_rad(bob_roll) * speed
		angles.y += bob_sin * speed * bob_up
		
	position = offset
	rotation = angles
	
func add_fall_kick(fall_strength: float) -> void:
	_fall_value = deg_to_rad(fall_strength)
	_fall_timer = fall_time
	
func add_damage_kick(pitch: float, roll: float, source: Vector3):
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	# The direction from the player to the damage source
	var direction = global_position.direction_to(source)
	
	# Comparing the direction of the damage source to the direction of the player
	# For example, if the source is directly in front of the player, forward_dot will be 1.0, while roll_dot will be 0.0
	var forward_dot = direction.dot(forward)
	var right_dot = direction.dot(right)
	_damage_pitch = deg_to_rad(pitch) * forward_dot
	_damage_roll = deg_to_rad(roll) * right_dot
	_damage_timer = damage_time

func add_weapon_kick(pitch: float, yaw:float, roll:float) ->void:
	_weapon_kick_angles.x += deg_to_rad(pitch)
	_weapon_kick_angles.y += deg_to_rad(randf_range(-yaw, yaw))
	_weapon_kick_angles.z += deg_to_rad(randf_range(-roll, roll))
	

func add_screen_shake(amount:float, seconds:float) -> void:
	if _screen_shake_tween:
		_screen_shake_tween.kill()
	
	_screen_shake_tween = create_tween()
	_screen_shake_tween.tween_method(update_screen_shake.bind(amount), 0.0, 1.0, seconds).set_ease(Tween.EASE_OUT)
	
func update_screen_shake(alpha: float, amount: float) ->void:
	amount = remap(amount, 0.0, 1.0, _MIN_SCREEN_SHAKE, _MAX_SCREEN_SHAKE)
	# This ensures the shaking effect to decrease over time.
	var current_shake_amount = amount * (1.0 - alpha)
	h_offset = randf_range(-current_shake_amount, current_shake_amount)
	v_offset = randf_range(-current_shake_amount, current_shake_amount)

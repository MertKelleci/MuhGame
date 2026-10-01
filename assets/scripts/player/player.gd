class_name PlayerController extends CharacterBody3D
@export var acceleration : float = 1.0
@export var decaleration : float = 0.8
@export var debug : bool = false
@export_category("References")
@export var camera : CameraController
@export var state_chart : StateChart
@export var standing_collision : CollisionShape3D

var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var speed : float = 10.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dev_exit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("dev_reload"):
		get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# This gets the input directions vector	
	_input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	# This gets the vertical velocity (no jumping/falling)
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.z)
	# This adjust our direction so that it's toward the direction we are looking at, and then normalizes it so that moving diagonally doesn't go faster than normal.
	var direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * speed, acceleration)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, decaleration)
		
	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y)
	velocity = _movement_velocity
	move_and_slide()

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)

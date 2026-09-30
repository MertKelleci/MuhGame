class_name CameraController extends Node3D
@export var debug : bool
@export_category("References")
@export var player_controller : PlayerController
@export_category("Camera Settings")
# This is used to clamp the camera rotation
@export_range(-90, -60) var tilt_lower_limit : int =  -90
@export_range(60, 90) var tilt_upper_limit : int =  90

var _rotation : Vector3

func update_camera_rotation(input: Vector2) -> void:
	_rotation.x += input.y
	_rotation.y += input.x
	_rotation.x = clamp(_rotation.x, deg_to_rad(tilt_lower_limit), deg_to_rad(tilt_upper_limit))
	
	# We seperate the rotation of the camera into horizontal and vertical rotations.
	# While the horizontal rotations should rotate the player, vertical rotations shouldn't.
	var _player_rotation = Vector3(0.0, _rotation.y, 0.0)
	var _camera_rotation = Vector3(_rotation.x, 0.0, 0.0)
	
	# Transforming the basis works differently from simply changing the rotation property.
	# Rotating the basis adjusts the transform, which also changes the direction player is looking at.
	transform.basis = Basis.from_euler(_camera_rotation)
	player_controller.update_rotation(_player_rotation)
	_rotation.z = 0.0

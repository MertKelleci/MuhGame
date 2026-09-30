class_name MouseCaptureComponent extends Node
@export var debug : bool = false
@export_category("Mouse Capture Settings")
@export var current_mouse_mode : Input.MouseMode = Input.MOUSE_MODE_CAPTURED
@export var mouse_sensitivity : float = 0.005
@export var camera_controller : CameraController

var _capture_mouse : bool
var _mouse_input : Vector2

func _unhandled_input(event: InputEvent) -> void:
	# The following check is for two things respectfuly:
	# 1. Is the unhandled input event is a mouse motion
	# 2. Is the current mouse the one we want. Without this one, moving the mouse in other places, such as menus, would make the character look around.
	_capture_mouse = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	
	if _capture_mouse:
		_mouse_input.x += -event.screen_relative.x * mouse_sensitivity
		_mouse_input.y += -event.screen_relative.y * mouse_sensitivity
		
		camera_controller.update_camera_rotation(_mouse_input)
		
	if debug:
		print(_mouse_input)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = current_mouse_mode


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# This prevents the mouse movement from being cumulative
	_mouse_input = Vector2.ZERO

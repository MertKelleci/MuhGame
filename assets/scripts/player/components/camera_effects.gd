class_name CameraEffects extends Camera3D
@export_category("References")
@export var player : PlayerController

@export_category("Enable Tilt")
@export var tilt : bool

@export_category("Kick & Recoil Settings")
@export_category("Run Tilt")
@export var run_pitch : float = 0.1
@export var run_roll : float = 0.25
@export var max_pitch : float = 1.0
@export var max_roll : float = 2.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Node3D
@export var player : PlayerController
@export_category("Damage Values")
@export var pitch := 1.0
@export var roll := 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hurt_player"):
		player.camera_effects.add_damage_kick(pitch,roll, global_position)
		

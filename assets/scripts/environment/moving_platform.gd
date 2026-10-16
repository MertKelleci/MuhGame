@tool
class_name MovingPlatform extends AnimatableBody3D
# This 'tool' line makes it so that the script is running in the editor.
# And we need that to happen because when we build the map, funcgodot will run the script and tell the object what to do with all the information.


@export var move_distance := 2.0
@export var move_time := 2.0
@export var move_direction := Vector3(0, 1, 0)
# Called when the node enters the scene tree for the first time.

var start_position: Vector3
var end_position: Vector3
var platform_tween: Tween


func _func_godot_apply_properties(entity_properties: Dictionary):
	move_distance = entity_properties["move_distance"] as float
	move_time = entity_properties["move_time"] as float
	move_direction = entity_properties["move_direction"] as Vector3

func _ready() -> void:
	if not Engine.is_editor_hint():
		start_position = global_position
		end_position = start_position + (move_direction.normalized() * move_distance)
		_start_movement()

func _start_movement() -> void:
	platform_tween = create_tween()
	platform_tween.set_loops()
	platform_tween.tween_property(self, "global_position", end_position, move_time)
	platform_tween.tween_property(self, "global_position", start_position, move_time)

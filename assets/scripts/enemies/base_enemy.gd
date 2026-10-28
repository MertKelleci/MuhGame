class_name BaseEnemy extends CharacterBody3D

@export var enemy_groups: Array[String] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for group in enemy_groups:
		add_to_group(group)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_triggered() -> void:
	pass

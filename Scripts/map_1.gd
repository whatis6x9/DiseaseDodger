extends Node3D

@onready var player = $BubbleBoy

func _ready() -> void:
	MenuMusic.stop()

func _physics_process(delta: float) -> void:
	get_tree().call_group("Enemies","update_target_location",player.global_transform.origin)

func game_over():
	get_tree().call_deferred("change_scene_to_file","res://game_over.tscn")

func _on_bubble_boy_no_hp_left() -> void:
	game_over()


func _on_game_timeout_timeout() -> void:
	game_over()

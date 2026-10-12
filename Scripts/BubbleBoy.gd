extends RigidBody3D

signal no_hp_left

@export var health :float = 100
@export var damage :float = 50
@export var Tex2:Texture2D
var real_value : float

func _physics_process(delta: float) -> void:
	pass

func _on_hurt_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemies"):
		health -= damage
		take_damage(damage)

func _ready() -> void:
	$Visuals/Sprite3D/SubViewport/Panel/ProgressBar.max_value = health
	$Visuals/Sprite3D/SubViewport/Panel/ProgressBar.value = health
	real_value = health
	
func take_damage(damage: float):
	real_value -= damage
	
	create_tween().tween_property($Visuals/Sprite3D/SubViewport/Panel/ProgressBar, "value", real_value, 0.3)
	
	if real_value <= 0.1:
		no_hp_left.emit()

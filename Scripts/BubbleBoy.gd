extends RigidBody3D

@export var health :float = 100
@export var damage :float = 50
@export var Tex2:Texture2D

func _physics_process(delta: float) -> void:
	print(health)
	


func _on_hurt_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemies"):
		health -= damage

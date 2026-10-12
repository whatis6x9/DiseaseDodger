extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var platform = $"../Platform/NavigationRegion3D"
@export var SPEED = 2.0

var xform: Transform3D

func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	# Rotates the enemy to align with ground.
	if $RayCast3D.get_collider() == $"../Platform" and velocity != Vector3(0,0,0):
		align_with_floor($RayCast3D.get_collision_normal())
		global_transform = global_transform.interpolate_with(xform, 0.2)
	elif not is_on_floor():
		align_with_floor(Vector3.UP)
		global_transform = global_transform.interpolate_with(xform, 0.2)
		
	new_velocity -= $RayCast3D.get_collision_normal() * 75 * delta
	
	#Moves the enemy, and uses the agent avoid feature implimented within the last function.
	nav_agent.set_velocity(new_velocity)
	
func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_target_reached():
	print("HIT")

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
	
func align_with_floor(floor_normal):
	xform = global_transform
	xform.basis.y = floor_normal
	xform.basis.x = -xform.basis.z.cross(floor_normal)
	xform.basis = xform.basis.orthonormalized()

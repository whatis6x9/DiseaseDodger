extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var rotate_amount = 0.02

var default_rotate

func _ready() -> void:
	default_rotate = transform.basis

func _physics_process(delta: float) -> void:
	var input = gather_input()
		
	if input.input_direction.y == 1 && transform.basis.y[2] < 0.5:
		transform.basis = Basis(Vector3(1,0,0),rotate_amount) * transform.basis
	elif input.input_direction.y == -1 && transform.basis.y[2] > -0.6:
		transform.basis = Basis(Vector3(1,0,0),-rotate_amount) * transform.basis
	elif input.input_direction.x == -1 && transform.basis.x[1] < 0.5:
		transform.basis = Basis(Vector3(0,0,1),rotate_amount) * transform.basis
	elif input.input_direction.x == 1 && transform.basis.x[1] > -0.5:
		transform.basis = Basis(Vector3(0,0,1),-rotate_amount) * transform.basis

	move_and_slide()

func gather_input() -> InputPackage:
	var new_input = InputPackage.new()
	
	new_input.input_direction = Input.get_vector("left", "right", "forward", "backward")
	return new_input

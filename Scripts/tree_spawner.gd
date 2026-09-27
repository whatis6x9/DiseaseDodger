extends Node3D

@export var obstacles: Array[PackedScene]
@export var nextWaveTime: float = 2.5
@export var obstaclesPerWave: int = 2
@export var maxWaves := -1

@onready var timer: Timer = $Timer

var currentWave = 0
var randomGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	timer.wait_time = nextWaveTime
	timer.start()

func _on_timer_timeout() -> void:
	for i in obstaclesPerWave:
		var randomObstacle = obstacles.pick_random().instantiate()
		$".".add_child.call_deferred(randomObstacle)
		print(_get_random_point())
		randomObstacle.position = _get_random_point()*Vector3(5,0,5)
	
	currentWave += 1

func _get_random_point():
	var collisionShape: CollisionShape3D = get_child(0)
	var halfSize = collisionShape.shape.size / 2
	return collisionShape.global_position + _get_random_point_box_shape(halfSize)
		
func _get_random_point_box_shape(halfSize):
	var xPos = randomGenerator.randf_range(-halfSize.x, halfSize.x) + global_position.x
	var zPos = randomGenerator.randf_range(-halfSize.z, halfSize.z) + global_position.z
	
	return Vector3(xPos, global_position.y, zPos)

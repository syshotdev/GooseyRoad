extends CharacterBody3D

# Logs or lillypads
class_name Debris

@export var logScene : PackedScene
@export var lillyScene : PackedScene
@export var logSpawningPosition : Node3D
@export var collisionShape : CollisionShape3D
@export var playerDetectionArea : Area3D

@onready var direction : Vector3 = Vector3(-1, 0, 0).rotated(Vector3.UP, global_rotation.y)# (Rotates vector based on rotation, as I want it to go locally left not globally left.)

var logSize : float = 1
var player : Player = null


func _ready():
	var isLog := randi_range(0,1) == 0
	
	if(isLog):
		makeLog(randi_range(1,3))
	else:
		makeLillyPad()
	
	velocity = Constants.debrisSpeed * direction # Jump start velocity


func _process(delta):
	if(player != null):
		player.targetPos = round(player.targetPos)
		# Move player along with thing
		player.targetPos.x = global_position.x
		player.position.x = global_position.x
	
	move(delta)
	move_and_slide()


# Moves in the general direction of left.
func move(delta : float):
	# Speed of car, delta, and direction of movement
	velocity += Constants.debrisSpeed * delta * direction



func makeLog(length : int):
	for logNumber in range(length):
		var log := logScene.instantiate()
		add_child(log)
		log.position = logSpawningPosition.position
		log.position += logNumber * Vector3(logSize, 0, 0) # One after another log
	
	collisionShape.scale.x = length * logSize
	collisionShape.position.x = length / 2
	playerDetectionArea.scale.x = length * logSize
	playerDetectionArea.position.x = length / 2


func makeLillyPad():
	var lillyPad := lillyScene.instantiate()
	add_child(lillyPad)
	lillyPad.position = logSpawningPosition.position


func onBodyEntered(body):
	if(body is Player):
		player = body


func onBodyExited(body):
	if(body is Player):
		player = null

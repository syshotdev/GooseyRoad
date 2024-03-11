extends CharacterBody3D

class_name Player

signal playerMoved(newPos : Vector3)

@export var model : Node3D # Model for making goose look around

@onready var targetPos : Vector3 = global_position
var directionDetectionArea : Dictionary # Key: direction, Value: detection area
var detectionAreaThings : Dictionary # Key: detection area, Value: Array or dictionary of things currently in it.


func _ready():
	initializeDetectionAreaVars()


func _process(delta):
	# Smoothly go to target pos
	position = lerp(position, targetPos, 0.5)


func _input(event):
	# Guard clause to check if keyboard key
	if not event is InputEventKey:
		return
	
	var direction := getActionJustVectored()
	# If direction is 0, don't move on cause we didn't move
	if(direction == Vector3.ZERO):
		return
	
	rotateGooseInDir(direction) # Rotate to check if colliding
	if(!isDirectionMovable(direction)):
		return
	
	targetPos += direction # Target position
	playerMoved.emit(position)


func getActionJustVectored() -> Vector3:
	var output : Vector3 = Vector3.ZERO
	
	# If going forward, backward, left, right, up, or down, it gives a vector with those.
	if(Input.is_action_just_pressed("left")):
		output.x = -1
	elif(Input.is_action_just_pressed("right")):
		output.x = 1
	elif(Input.is_action_just_pressed("forward")):
		output.z = -1
	elif(Input.is_action_just_pressed("backward")):
		output.z = 1
	
	#print(position)
	
	return output

# Checks whether the current direction is a moveable one.
func isDirectionMovable(direction : Vector3) -> bool:
	# If we're trying to move in a direction and something blocking, return false
	var areaWeChecking : Area3D = directionDetectionArea[direction]
	if(detectionAreaThings[areaWeChecking].size() > 0):
		return false
	
	return true

# Rotates goose from coordinate
func rotateGooseInDir(direction : Vector3):
	model.look_at(position + direction)

# Set up all directions to remember which detection area is in what direction
func initializeDetectionAreaVars():
	directionDetectionArea[Vector3(0,0,-1)] = $Forward
	directionDetectionArea[Vector3(0,0,1)] = $Backward
	directionDetectionArea[Vector3(1,0,0)] = $Left
	directionDetectionArea[Vector3(-1,0,0)] = $Right
	
	for area in directionDetectionArea.values():
		var dictionary : Dictionary = {}
		# For area, set empty dictionary for current things in area
		detectionAreaThings[area] = dictionary
		area.bodyEnteredCircumstances.connect(detectionAreaEntered)
		area.bodyExitedCircumstances.connect(detectionAreaExited)


# Idk what "body" is (The type, like CharacterBody3D)
func detectionAreaEntered(area : Area3D, body):
	# At the area, add body to array of things in it
	detectionAreaThings[area][body] = 0

func detectionAreaExited(area : Area3D, body):
	detectionAreaThings[area].erase(body)

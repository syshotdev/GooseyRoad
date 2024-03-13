extends CharacterBody3D

class_name Player

signal playerMoved(newPos : Vector3)

@export var detectionArea : Area3D

@onready var targetPos : Vector3 = global_position
var lastDirection : Vector3 = Vector3.ZERO
var thingsInDetectionArea : Dictionary # Key: thing inside area, Value: 0
var extraBooleanForDelay : bool = false


func _physics_process(delta):
	# Smoothly go to target pos
	position = lerp(position, targetPos, 0.5)
	
	# If we didn't move at all, return
	if(lastDirection == Vector3.ZERO):
		return
	# Waits an extra tick lol (for waiting till area3d updates what's inside it)
	if(extraBooleanForDelay == false):
		extraBooleanForDelay = true
	elif(isDirectionMovable(lastDirection)):
		targetPos += lastDirection # Target position
		lastDirection = Vector3.ZERO # Reset direction
		extraBooleanForDelay = false # Reset delay


func _input(event):
	# Guard clause to check if keyboard key
	if not event is InputEventKey:
		return
	
	var direction := getActionJustVectored()
	# If direction is 0, don't move on cause we didn't move
	if(direction == Vector3.ZERO):
		return
	
	rotateGooseInDir(direction)
	lastDirection = direction
	playerMoved.emit(position)


# Gets the action just pressed, like wasd
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
	if(thingsInDetectionArea.size() > 0):
		return false
	return true

# Rotates goose in direction, direction being vec3
func rotateGooseInDir(direction : Vector3):
	look_at(position + direction)

# Idk what "body" is (The type, like CharacterBody3D)
func detectionAreaEntered(body):
	# At the area, add body to array of things in it
	thingsInDetectionArea[body] = 0

func detectionAreaExited(body):
	if(thingsInDetectionArea.has(body)):
		thingsInDetectionArea.erase(body)

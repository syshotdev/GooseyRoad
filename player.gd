extends CharacterBody3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _input(event):
	var out := getActionJustVectored()
	moveDirSquare(out * Constants.blockSize)


func getActionJustVectored() -> Vector3i:
	var output : Vector3i = Vector3i(0, 0, 0)
	
	# If going forward, backward, left, right, up, or down, it gives a vector with those.
	if(Input.is_action_just_pressed("left")):
		output.x = -1
	elif(Input.is_action_just_pressed("right")):
		output.x = 1
	elif(Input.is_action_just_pressed("forward")):
		output.z = -1
	elif(Input.is_action_just_pressed("backward")):
		output.z = 1
	elif(Input.is_action_just_pressed("jump")):
		output.y = 1
	
	return output

# Basically, when given a direction, it goes exactly one unit in that direction while making it smooth.
# TODO: make the animation smooth and consider collisions
func moveDirSquare(direction : Vector3):
	position += direction

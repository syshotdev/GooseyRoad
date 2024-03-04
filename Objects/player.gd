extends CharacterBody3D

var targetPos : Vector3

func _input(event):
	var out := getActionJustVectored()
	targetPos += out


func getActionJustVectored() -> Vector3:
	var output : Vector3 = Vector3(0, 0, 0)
	
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
	
	print(position)
	
	return output


func _process(delta):
	# Smoothly go to target pos
	position = lerp(position, targetPos, 0.5)

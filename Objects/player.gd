extends CharacterBody3D

class_name Player

signal playerMoved(newPos : Vector3)

@onready var targetPos : Vector3 = global_position

func _input(event):
	# Guard clause to check if keyboard key
	if not event is InputEventKey:
		return
	
	var out := getActionJustVectored()
	targetPos += out
	playerMoved.emit(position)


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
	
	#print(position)
	
	return output


func _process(delta):
	# Smoothly go to target pos
	position = lerp(position, targetPos, 0.5)

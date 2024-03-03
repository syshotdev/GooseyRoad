extends CharacterBody3D

class_name Car

@export var direction : Vector3


func _process(delta):
	# Speed of car, delta, and direction of movement
	velocity += Constants.carSpeed * delta * direction.normalized()
	
	move_and_slide()

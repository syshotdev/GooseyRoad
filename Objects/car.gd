extends CharacterBody3D

class_name Car

@export var direction : Vector3

func _ready():
	# Jumpstart velocity
	velocity = Constants.carSpeed * direction.rotated(Vector3.UP, global_rotation.y)


func _process(delta):
	# Speed of car, delta, and direction of movement
	# (Rotates vector based on rotation, as I want it to go locally left not globally left.)
	velocity += Constants.carSpeed * delta * direction.rotated(Vector3.UP, global_rotation.y)
	
	move_and_slide()

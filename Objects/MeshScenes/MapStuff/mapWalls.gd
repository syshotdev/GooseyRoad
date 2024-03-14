extends Node3D

# walls
@export var wallLeft : StaticBody3D
@export var wallRight : StaticBody3D

func _ready():
	wallLeft.position.x = -Constants.widthOfMap / 2
	wallRight.position.x = Constants.widthOfMap / 2

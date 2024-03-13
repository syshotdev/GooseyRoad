extends CSGBox3D

# This class is to make the base shape of the map for every strip tyep

@export var collisionShape : CollisionShape3D
@export var wallLeft : StaticBody3D
@export var wallRight : StaticBody3D

func _ready():
	size.x = Constants.widthOfMap
	collisionShape.scale.x = Constants.widthOfMap
	wallLeft.position.x = -Constants.widthOfMap / 2
	wallRight.position.x = Constants.widthOfMap / 2

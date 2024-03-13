extends CSGBox3D

@export var collisionShape : CollisionShape3D

func _ready():
	size.x = Constants.widthOfMap
	collisionShape.scale.x = Constants.widthOfMap

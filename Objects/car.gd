extends CharacterBody3D

class_name Car

@export var collisionShape : CollisionShape3D # For turning off collisions

# (Rotates vector based on rotation, as I want it to go locally left not globally left.)
@onready var direction : Vector3 = Vector3(-1, 0, 0).rotated(Vector3.UP, global_rotation.y)

var crashed : bool = false

func _ready():
	# Jumpstart velocity
	velocity = Constants.carSpeed * direction


func _process(delta):
	move_and_slide()
	
	if(crashed):
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	else:
		moveNormally(delta)



# Shorten code in _process
func moveNormally(delta : float):
	# Speed of car, delta, and direction of movement
	velocity += Constants.carSpeed * delta * direction
	
	# Check whether collided with player
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		
		if(collision.get_collider() is Player):
			doCrash()
			return

# For actually looking like it crashed
func doCrash():
	# Make collisions with player no longer work
	collisionShape.disabled = true
	velocity += direction * Constants.carSpeed #randi_range(Constants.carSpeed, Constants.carSpeed * 5)
	velocity.y += randi_range(Constants.carSpeed, Constants.carSpeed * 5)
	crashed = true

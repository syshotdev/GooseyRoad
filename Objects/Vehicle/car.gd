extends CharacterBody3D

class_name Car

signal carCrashed(score : int) # Score = how much score you get for crashing

@export var collisionShape : CollisionShape3D # For turning off collisions
@export var particleEmitter : GPUParticles3D # For particles and crash
# (Rotates vector based on rotation, as I want it to go locally left not globally left.)
@onready var direction : Vector3 = Vector3(-1, 0, 0).rotated(Vector3.UP, global_rotation.y)


var thingsInDetectionArea : Dictionary # Key: object's collision thing, Value: 0
var crashed : bool = false


func _ready():
	# Jumpstart velocity
	velocity = Constants.carSpeed * direction


func _process(delta):
	move_and_slide()
	
	# Do one of these things
	if(crashed):
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	elif(isCollidedWithPlayer()):
		doCrash()
	elif(thingsInDetectionArea.size() > 0):
		brake(delta)
	else:
		move(delta)


# Checks collision with player, and returns true or false
func isCollidedWithPlayer() -> bool:
	# Check whether collided with player
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		
		if(collision.get_collider() is Player):
			return true
	return false

# Moves in the general direction of left.
func move(delta : float):
	# Speed of car, delta, and direction of movement
	velocity += Constants.carSpeed * delta * direction

# The point of this function is to lessen the velocity by a braking amount
func brake(delta : float):
	velocity = lerp(velocity, Vector3.ZERO, delta * Constants.brakingPower)

# For actually looking like it crashed
func doCrash():
	particleEmitter.emitting = true
	var carCrashScore : int = Constants.carCrashScore # no fancy equation for scoring because velocity is below 0 for some reason
	carCrashed.emit(carCrashScore)
	crashed = true
	# Make collisions with player no longer work
	collisionShape.disabled = true
	velocity += direction * Constants.carSpeed #randi_range(Constants.carSpeed, Constants.carSpeed * 5)
	velocity.y += randi_range(Constants.carSpeed, Constants.carSpeed * 5)

# For keeping track when to brake
func detectedBodyEntranceInDetectionArea(body):
	thingsInDetectionArea[body] = 0

func detectedBodyExitInDetectionArea(body):
	thingsInDetectionArea.erase(body)

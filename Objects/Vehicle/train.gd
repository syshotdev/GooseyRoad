extends CharacterBody3D

class_name Train

signal trainCrashed(score : float)

const trainCarSize := 2.5
@export var trainCarScene : PackedScene
@export var collisionShape : CollisionShape3D # For turning off collisions

@onready var trainCarOrigin := $trainCarOrigin
@onready var particleEmitter := $Sparks
@onready var direction : Vector3 = Vector3(-1, 0, 0).rotated(Vector3.UP, global_rotation.y)# (Rotates vector based on rotation, as I want it to go locally left not globally left.)

var physicsObjects : Array[RigidBody3D] = []
var crashed : bool = false


func _ready():
	makeTrain()
	velocity = Constants.trainSpeed * direction # Jump start velocity


func _process(delta):
	# Do one of these things
	if(crashed):
		return
	elif(isCollidedWithPlayer()):
		doCrash()
		trainSegmentsArePhysicsObjects(true)
	else:
		pass
	move(delta)
	move_and_slide()

# Creates train + physics objects
func makeTrain():
	var numberOfCarts : int = randi_range(Constants.minNumberOfTrainCarts, Constants.maxNumberOfTrainCarts)
	physicsObjects.resize(numberOfCarts + 1) # +1 is train puller
	physicsObjects[0] = $trainPuller
	
	# Make and position meshes
	for cartNumber in range(numberOfCarts):
		var cart := trainCarScene.instantiate()
		physicsObjects[cartNumber + 1] = cart
		add_child(cart)
		cart.position = trainCarOrigin.position
		cart.position += cartNumber * Vector3(trainCarSize, 0, 0) # One after another cart
	
	trainSegmentsArePhysicsObjects(false) # Set processing to false (to avoid self-collision and bugginess)


func trainSegmentsArePhysicsObjects(boolean : bool):
	for object : RigidBody3D in physicsObjects:
		object.get_child(0).disabled = !boolean


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
	velocity += Constants.trainSpeed * delta * direction

# For actually looking like it crashed
func doCrash():
	particleEmitter.emitting = true
	var trainCrashScore : int = Constants.trainCrashScore # no fancy equation for scoring because velocity is below 0 for some reason
	trainCrashed.emit(trainCrashScore)
	crashed = true
	# Make collisions with player no longer work
	collisionShape.disabled = true
	
	
	var randomSpinnyVector : Vector3 = Vector3(randi_range(0, 360),randi_range(180, 360),randi_range(0, 360))
	var speedOfLinearVelocity : float = Constants.trainSpeed / 8 # Controlled variable because sometimes too large
	for object : RigidBody3D in physicsObjects:
		# Basically just velocity
		object.linear_velocity += velocity
		object.linear_velocity.z += speedOfLinearVelocity * randf_range(-1,1)
		object.linear_velocity.y += randi_range(speedOfLinearVelocity, speedOfLinearVelocity * 5)
		object.inertia += randomSpinnyVector

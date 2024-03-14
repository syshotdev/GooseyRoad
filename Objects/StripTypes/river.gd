extends Node3D

@export var debrisScene : PackedScene
@export var debrisSpawningTimer : Timer
@export var debrisSpawningPoint : Node3D
@export var debrisRemovalArea : Area3D
@export var playerDownArea : Area3D

@onready var lengthOfRoad = Constants.widthOfMap

var player : Player = null

# Set up road
func _ready():
	resizeRoad(lengthOfRoad)
	randomizeLogTimer()
	debrisSpawningTimer.start()


func resizeRoad(width : float):
	debrisSpawningPoint.position.x = width / 2.0 # Make it on right
	debrisRemovalArea.position.x = -(width + 4.0) / 2.0 # Make it on left
	playerDownArea.scale.x = width


func _physics_process(delta):
	if(player != null):
		player.inRiver = true


func debrisSpawningTimerEnded():
	spawnDebris()
	randomizeLogTimer()
	debrisSpawningTimer.start()

# For spawning log
func spawnDebris():
	var debris := debrisScene.instantiate()
	debris.position = debrisSpawningPoint.position
	add_child(debris)


func randomizeLogTimer():
	debrisSpawningTimer.set_wait_time(randf_range(1, 3))


func debrisRemovalAreaEntered(body : Node3D):
	var potentialDebris := body
	
	if(potentialDebris is Debris):
		potentialDebris.queue_free()

# For pulling player down into river
func possiblePlayerBodyEntered(body):
	if(body is Player):
		player = body

func possiblePlayerBodyExited(body):
	if(body is Player):
		body.inRiver = false
		player = null

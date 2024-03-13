extends Node3D

@export var trainScene : PackedScene
@export var trainSpawningTimer : Timer
@export var trainSpawningPoint : Node3D
@export var trainRemovalArea : Area3D

@onready var lengthOfRoad = Constants.widthOfMap

# Set up road
func _ready():
	resizeRoad(lengthOfRoad)
	randomizeTrainTimer()
	trainSpawningTimer.start()


func resizeRoad(width : float):
	trainSpawningPoint.position.x = width / 2.0 # Make it on right
	trainRemovalArea.position.x = -(width + 4.0) / 2.0 # Make it on left


func trainSpawningTimerEnded():
	spawnTrain()
	randomizeTrainTimer()
	trainSpawningTimer.start()

# For spawning train
func spawnTrain():
	var train := trainScene.instantiate()
	train.position = trainSpawningPoint.position
	train.trainCrashed.connect(trainCrashed)
	add_child(train)


func randomizeTrainTimer():
	trainSpawningTimer.set_wait_time(randf_range(1, 5))


# When a train crashes, it sends signal to give player +~30 score
func trainCrashed(score : float):
	get_parent().addScore(score) # Just call the parent addScore function


func trainRemovalAreaEntered(body : Node3D):
	var potentialTrain := body
	
	if(potentialTrain is Train):
		potentialTrain.queue_free()

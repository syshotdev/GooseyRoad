extends Node3D

@export var carScene : PackedScene

@onready var lengthOfRoad = Constants.widthOfMap
@onready var carSpawningTimer : Timer = $CarSpawningTimer
@onready var carSpawningPoint : Node3D = $CarSpawningPoint
@onready var carRemovalArea : Area3D = $CarRemovalArea

# Set up road
func _ready():
	resizeRoad(lengthOfRoad)
	randomizeCarTimer()
	carSpawningTimer.start()


func resizeRoad(width : float):
	carSpawningPoint.position.x = width / 2.0 # Make it on right
	carRemovalArea.position.x = -(width + 4.0) / 2.0 # Make it on left

# For spawning car
func spawnCar():
	var car := carScene.instantiate()
	car.position = carSpawningPoint.position
	car.carCrashed.connect(carCrashed)
	add_child(car)


func carRemovalAreaEntered(area : Area3D):
	var potentialCar := area.get_parent()
	
	if(potentialCar is Car):
		potentialCar.queue_free()


func carSpawningTimerEnded():
	spawnCar()
	randomizeCarTimer()
	carSpawningTimer.start()

# When a car crashes, it sends signal to give player +~30 score
func carCrashed(score : float):
	get_parent().addScore(score) # Just call the addScore signal


func randomizeCarTimer():
	carSpawningTimer.set_wait_time(randf_range(1, 5))

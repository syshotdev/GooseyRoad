extends Node3D

@export var isGoingLeft : bool = true
@export var carScene : PackedScene

@onready var lengthOfRoad = Constants.widthOfMap
@onready var roadMesh : CSGBox3D = $RoadMesh
@onready var carSpawningTimer : Timer = $CarSpawningTimer
@onready var carSpawningPoint : Node3D = $CarSpawningPoint
@onready var carRemovalArea : Area3D = $CarRemovalArea

# Set up road
func _ready():
	resizeRoad(lengthOfRoad)


func resizeRoad(width : float):
	roadMesh.size.x = width
	carSpawningPoint.position.x = width / 2.0 # Make it on right
	carRemovalArea.position.x = -(width + 4.0) / 2.0 # Make it on left

# For spawning car
func spawnCar():
	var car := carScene.instantiate()
	car.position = carSpawningPoint.position
	add_child(car)


func carRemovalAreaEntered(area : Area3D):
	var potentialCar := area.get_parent()
	
	if(potentialCar is Car):
		potentialCar.queue_free()


func carSpawningTimerEnded():
	spawnCar()
	carSpawningTimer.start()

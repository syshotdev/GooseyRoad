extends Node3D

@export var isGoingLeft : bool = true
@export var carScene : PackedScene

@onready var lengthOfRoad = Constants.widthOfMap
@onready var roadMesh : CSGBox3D = $RoadMesh
@onready var carSpawningPoint : Node3D = $CarSpawningPoint
@onready var carRemovalArea : Area3D = $CarRemovalArea

# Set up road
func _ready():
	roadMesh.size.x = lengthOfRoad # Might work, I don't know
	roadMesh.request_ready()
	carSpawningPoint.position.x = lengthOfRoad / 2.0 # Make it on right
	carRemovalArea.position.x = -lengthOfRoad / 2.0 # Make it on left
	spawnCar()

# For spawning car
func spawnCar():
	var car := carScene.instantiate()
	car.position = carSpawningPoint.position
	add_child(car)


func _process(delta : float):
	pass


func carRemovalAreaEntered(area : Area3D):
	var potentialCar := area.get_parent()
	
	if(potentialCar is Car):
		potentialCar.queue_free()

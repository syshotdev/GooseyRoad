extends Node3D

@export var isGoingLeft : bool = true
@export var carScene : PackedScene

@onready var lengthOfRoad = Constants.widthOfMap
@onready var roadMesh : CSGBox3D = $RoadMesh
@onready var carSpawningPoint : Node3D = $CarSpawningPoint
@onready var carRemovalArea : Area3D = $CarRemovalArea

# Set up road
func _ready():
	# Rotate the entire thing 180 half the time
	if(randi_range(0, 1) == 1):
		rotate_y(deg_to_rad(180))
	
	roadMesh.size.x = lengthOfRoad
	carSpawningPoint.position.x = lengthOfRoad / 2.0 # Make it on right
	carRemovalArea.position.x = -lengthOfRoad / 2.0 # Make it on left
	spawnCar()


# For spawning car
func spawnCar():
	var car := carScene.instantiate()
	car.position = carSpawningPoint.position
	add_child(car)


func carRemovalAreaEntered(area : Area3D):
	var potentialCar := area.get_parent()
	
	if(potentialCar is Car):
		potentialCar.queue_free()

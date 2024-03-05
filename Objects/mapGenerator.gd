extends Node3D

class_name MapGenerator

# The basic idea for this class is that there are strips of the map rather than individual blocks.
# Each strip is either ground or water, and if land, forest, road, or train.
@export var roadScene : PackedScene

@onready var modules : Array[PackedScene] = [roadScene] # Houses all of the packed scenes for easy shuffling
@onready var currentMap : Array = [] # Houses all of the strips for easy access
@onready var currentStripPosition : int = 0 # the id of the current strip (To position one after another)


func _ready():
	for i in range(Constants.mapAmountOfStrips):
		generateNextMapStrip() # Pregenerate map


# Takes a given map array and adds one module to it
func generateNextMapStrip():
	var randomScene : PackedScene = modules.pick_random()
	var instancedScene := randomScene.instantiate()
	
	currentMap.append(instancedScene)
	if(currentMap.size() > Constants.mapAmountOfStrips):
		currentMap.pop_front().queue_free() # Remove strip to free memory
	add_child(instancedScene)
	
	# Rotate the entire thing 180 half the time
	if(randi_range(0, 1) == 1):
		instancedScene.rotate_y(deg_to_rad(180))
	
	# Set the position to 1 module ahead of current one
	instancedScene.position = Vector3(0, 0, -currentStripPosition * Constants.blockSize)
	
	currentStripPosition += 1

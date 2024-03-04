extends Node3D

class_name MapGenerator

# The basic idea for this class is that there are strips of the map rather than individual blocks.
# Each strip is either ground or water, and if land, forest, road, or train.
@export var roadScene : PackedScene

@onready var modules : Array[PackedScene] = [roadScene] # Houses all of the packed scenes for easy shuffling
@onready var currentMap : Array = [] # Houses all of the strips for easy access
@onready var currentStripNumber : int = 0 # the id of the current strip


func _ready():
	generateNextMapStrip(currentMap)
	generateNextMapStrip(currentMap)
	generateNextMapStrip(currentMap)
	generateNextMapStrip(currentMap)


# Takes a given map array and adds one module to it
func generateNextMapStrip(map : Array):
	var randomScene : PackedScene = modules.pick_random()
	var instancedScene := randomScene.instantiate()
	
	map.append(instancedScene)
	add_child(instancedScene)
	# Set the position to 1 module ahead of current one
	instancedScene.position = Vector3(0, 0, -currentStripNumber * Constants.blockSize)
	
	currentStripNumber += 1

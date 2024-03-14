extends Node3D

class_name MapGenerator

signal updateScore(score : float)
signal carCrashed(score : float)

# The basic idea for this class is that there are strips of the map rather than individual blocks.
# Each strip is either ground or water, and if land, forest, road, or train.
@export var roadScene : PackedScene
@export var trainScene : PackedScene
@export var riverScene : PackedScene
@export var forestScene : PackedScene
@export var plainsScene : PackedScene

@onready var modules : Array[PackedScene] = [roadScene, forestScene, trainScene, plainsScene, riverScene] # Houses all of the packed scenes for easy shuffling
@onready var currentMap : Array = [] # Houses all of the strips for easy access
@onready var currentStripPosition : int = -Constants.mapStripsBehindPlayer # the id of the current strip (To position one after another)
@onready var probabilities : Dictionary = { # Key: Scene, Value: Entries into pool of chance
	roadScene : 10,
	forestScene : 30,
	trainScene : 20,
	riverScene : 8,
	plainsScene : 1,
}


func _ready():
	while currentStripPosition < Constants.mapAmountOfStrips:
		generateNextMapStrip() # Pregenerate map


# Takes a given map array and adds one module to it
func generateNextMapStrip():
	var randomScene : PackedScene = modules.pick_random()
	var amountOfScenes : int = 1
	
	generateStrip(randomScene, amountOfScenes)
	randomize()
	
	addScore(amountOfScenes)


func generateStrip(scene : PackedScene, amount : int):
	var instancedScene := scene.instantiate()
	
	for i in range(amount):
		currentMap.append(instancedScene)
		
		if(currentMap.size() > Constants.mapAmountOfStrips):
			currentMap.pop_front().queue_free() # Remove strip to free memory
			# Rotate the entire thing 180 half the time
		
		if(randi_range(0, 1) == 1):
			scene.rotate_y(deg_to_rad(180))
		
		# Set the position to 1 module ahead of current one
		instancedScene.position = Vector3(0, 0, -currentStripPosition * Constants.blockSize)
		currentStripPosition += 1
		add_child(instancedScene)




func addScore(score : float):
	updateScore.emit(score)


func onCrash(score : float):
	carCrashed.emit(score)

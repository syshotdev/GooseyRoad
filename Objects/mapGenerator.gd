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

@onready var modules : Array[PackedScene] = [roadScene, forestScene, trainScene, riverScene] # Houses all of the packed scenes for easy shuffling
@onready var currentMap : Array = [] # Houses all of the strips for easy access
@onready var currentStripPosition : int = -Constants.mapStripsBehindPlayer # the id of the current strip (To position one after another)
@onready var probabilities : Dictionary = { # Key: Scene, Value: Entries into pool of chance
	roadScene : 10,
	forestScene : 30,
	trainScene : 20,
	riverScene : 4,
}


func _ready():
	var maxStripPosition = currentStripPosition
	while currentStripPosition < Constants.mapAmountOfStrips - Constants.mapStripsBehindPlayer:
		if(currentStripPosition <= 0):
			generateStrip(plainsScene, 1)
			continue # Don't generate next segment
		
		generateNextMapSegment() # Pregenerate map


# Takes a given map array and adds one module to it
func generateNextMapSegment():
	var randomScene : PackedScene = modules.pick_random()
	var amountOfScenes : int = randi_range(1, 2)
	
	generateStrip(randomScene, amountOfScenes)
	
	addScore(amountOfScenes)

# Pick a random scene with probabilites taken into account
func pickRandomScene():
	# All of them with proportional amounts of entries
	var arrayOfPackedScenes : Array = []
	# For each scene
	for scene in probabilities.keys():
		# Make an array of things filled with scene
		var arrayOfThings : Array[PackedScene] = []
		arrayOfThings.resize(probabilities[scene])
		arrayOfThings.fill(scene)
		
		# Add the arrayOfThings to total
		arrayOfPackedScenes.append_array(arrayOfThings)
	
	return arrayOfPackedScenes.pick_random()


func generateStrip(scene : PackedScene, amount : int):
	for i in range(amount):
		var instancedScene := scene.instantiate()
		currentMap.append(instancedScene)
		
		if(currentMap.size() > Constants.mapAmountOfStrips):
			currentMap.pop_front().queue_free() # Remove strip to free memoryw
			# Rotate the entire thing 180 half the time
		
		if(randi_range(0, 1) == 1):
			instancedScene.rotate_y(deg_to_rad(180))
		
		# Set the position to 1 module ahead of current one
		instancedScene.position = Vector3(0, 0, -currentStripPosition * Constants.blockSize)
		currentStripPosition += 1
		
		add_child(instancedScene)




func addScore(score : float):
	updateScore.emit(score)


func onCrash(score : float):
	carCrashed.emit(score)

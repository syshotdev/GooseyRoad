extends Node3D

@export var treeScene : PackedScene
@onready var treeSpawningPosition : Node3D = $TreeSpawningPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	generateForest(Constants.widthOfMap/2)


func generateForest(amountOfTrees):
	var stripNumbers : Array[int] = []
	for index in range(Constants.widthOfMap):
		stripNumbers.append(index)
	
	if(amountOfTrees > stripNumbers.size()):
		printerr("Too many trees to plant when not enough space :| ")
		return
	
	# Shuffle numbers
	stripNumbers.shuffle()
	
	# Go up until amountOfTrees and plant tree at each point
	for index in range(amountOfTrees):
		plantTreeAt(stripNumbers[index])

# Plants a tree at a place on strip
func plantTreeAt(blockPosition : float):
	var tree := treeScene.instantiate()
	add_child(tree)
	tree.position = treeSpawningPosition.position
	tree.position.x = blockPosition

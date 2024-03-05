extends Node3D

@export var mapGenerator : MapGenerator

var score : int = 0
var furthestGeneratedPosition : int = 0 : set = updateFurthestPosition # Goes up and is used for only extending the map when player moves forward

func playerMoved(newPos : Vector3):
	# If the furthest position is less than (absolutely) player's position, generate more sections
	if(furthestGeneratedPosition > abs(newPos.z)):
		return
	
	var amountOfStripsToMake : int = floor(abs(newPos.z) - furthestGeneratedPosition)
	# Add that many map strips
	for i in range(amountOfStripsToMake):
		mapGenerator.generateNextMapStrip()
	
	furthestGeneratedPosition += amountOfStripsToMake

# Updates the score when number goes up
func updateFurthestPosition(number : int):
	updateScore(number)
	furthestGeneratedPosition = number


func updateScore(score : int):
	$UI/Score.text = str("Score: ", score) # TEMPORARY!!

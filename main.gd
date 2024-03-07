extends Node3D

@export var mapGenerator : MapGenerator

var score : int = 0
# Used for extending map ahead of player
var lowestStripID : int = -Constants.mapStripsBehindPlayer # Basically pos of first strip, aka strip behind player
var playerHighestStripID : int = 0 # To keep track if the player went forward or backward
var highestStripID : int = Constants.mapStripsInFrontPlayer # mapAmountOfStrips ahead of mapStripsBehindPlayer

func playerMoved(newPos : Vector3):
	var playerStripID : int = abs(newPos.z) / Constants.blockSize
	
	generateNewStrips(playerStripID) # Aint broke, don't fix it. But could just use highest strip ID
	
	updateFromPlayerStrip(playerStripID)


func generateNewStrips(playerStripID : int):
	# Formula = difference between playerStrip and highestStrip, but highestStripID should equal playerStripID when remove offset
	var amountOfStripsToMake : int = playerStripID - (highestStripID - Constants.mapStripsInFrontPlayer)
	clampi(amountOfStripsToMake, 0, INF) # Clamp it because negative means player is going backwards
	
	for i in range(amountOfStripsToMake):
		mapGenerator.generateNextMapStrip()


# Updates the score when player moves
func updateFromPlayerStrip(playerStripID : int):
	updateScore(playerStripID)
	# Max for checking whether to actually lower or higher it (since chunking system wack)
	lowestStripID = max(playerStripID, playerHighestStripID) - Constants.mapStripsBehindPlayer
	highestStripID = max(playerStripID, playerHighestStripID) + Constants.mapStripsInFrontPlayer
	playerHighestStripID = max(playerStripID, playerHighestStripID) # Set HighestStripID to this one


func updateScore(score : int):
	$UI/Score.text = str("Score: ", score) # TEMPORARY!!

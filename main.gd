extends Node3D

@export var mapGenerator : MapGenerator
@export var cameraOrigin : Node3D
@export var player : Player

var score : int = 0
# Used for extending map ahead of player
var lowestStripID : int = -Constants.mapStripsBehindPlayer # Basically pos of first strip, aka strip behind player
var highestStripID : int = Constants.mapStripsInFrontPlayer # mapAmountOfStrips ahead of mapStripsBehindPlayer
var playerHighestStripPos : float = 0 # To keep track if the player went forward or backward

var cameraTargetPosition : Vector3 = Vector3.ZERO # For smoothly lerping between current and target position


func _process(delta):
	playerHighestStripPos += Constants.cameraSpeed * delta
	generateNewStrips(playerHighestStripPos)
	updateCameraPosition(playerHighestStripPos)
	updateFromPlayerStrip(playerHighestStripPos)
	isPlayerDead()


# Signal when player moves, updates current highest player position.
func playerMoved(newPos : Vector3):
	var playerStripID : float = abs(newPos.z) / Constants.blockSize
	playerHighestStripPos = max(playerStripID, playerHighestStripPos) # Only set if this strip higher than old one.

# Generate function of strips (Doesn't generate if player moves anywhere but forward)
func generateNewStrips(playerStripID : float):
	# Formula = difference between playerStrip and highestStrip, but highestStripID should equal playerStripID when remove offset
	var amountOfStripsToMake : int = floor(playerStripID - (highestStripID - Constants.mapStripsInFrontPlayer))
	clampi(amountOfStripsToMake, 0, INF) # Clamp it because negative means player is going backwards
	
	for i in range(amountOfStripsToMake):
		mapGenerator.generateNextMapStrip()

# Updates camera smoothly with playerStripID
func updateCameraPosition(playerStripID : float):
	# Negative z is forward, player strip ID only goes up
	cameraOrigin.position.z = lerp(cameraOrigin.position.z, -playerStripID * Constants.blockSize, 0.1)

# Updates the score and lowest and highest stripIDS
func updateFromPlayerStrip(playerStripID : float):
	updateScore(playerStripID)
	# Max for checking whether to actually lower or higher it (since chunking system wack)
	lowestStripID = playerHighestStripPos - Constants.mapStripsBehindPlayer
	highestStripID = playerHighestStripPos + Constants.mapStripsInFrontPlayer


func isPlayerDead():
	var playerStripID : float = -player.position.z / Constants.blockSize
	if(playerStripID < lowestStripID):
		print("Died") # IT WORKS!!!!!
		pass # Replace with endGame() function


func updateScore(score : int):
	self.score = score
	$UI/Score.text = str("Score: ", score) # TEMPORARY!!

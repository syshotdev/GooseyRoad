extends Node3D

signal died()
signal addAndUpdateScore(score : float)

@export var mapGenerator : MapGenerator
@export var player : Player
@export var cameraOrigin : Node3D
@export var cameraShaker : CameraShake
# Used for extending map ahead of player
var lowestStripID : int = -Constants.mapStripsBehindPlayer # Basically pos of first strip, aka strip behind player
var highestStripID : int = Constants.mapStripsInFrontPlayer # mapAmountOfStrips ahead of mapStripsBehindPlayer
var playerHighestStripPos : float = 0 # To keep track if the player went forward or backward

var cameraTargetPosition : Vector3 = Vector3.ZERO # For smoothly lerping between current and target position

func _ready():
	generateNewStrips(playerHighestStripPos)


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
	var amountOfStripsToMake : int = floor(playerStripID - mapGenerator.currentStripPosition + Constants.mapStripsInFrontPlayer)
	clampi(amountOfStripsToMake, 0, INF) # Clamp it because negative means player is going backwards
	
	# If we need to make even one new strip, call the function
	if(amountOfStripsToMake > 0):
		mapGenerator.generateNextMapSegment()

# Updates camera smoothly with playerStripID
func updateCameraPosition(playerStripID : float):
	# Negative z is forward, player strip ID only goes up
	cameraOrigin.position.z = lerp(cameraOrigin.position.z, -playerStripID * Constants.blockSize, 0.1)
	# Move with player x
	cameraOrigin.position.x = lerp(cameraOrigin.position.x, player.position.x, 0.1)

# Updates the lowest and highest stripIDS
func updateFromPlayerStrip(playerStripID : float):
	# Max for checking whether to actually lower or higher it (since chunking system wack)
	lowestStripID = playerStripID - Constants.mapStripsBehindPlayer
	highestStripID = playerStripID + Constants.mapStripsInFrontPlayer


func isPlayerDead():
	var playerStripID : float = -player.position.z / Constants.blockSize # Calculates playerStripID from player pos
	if(playerStripID < lowestStripID):
		died.emit()
	elif(player.position.y < -0.5):
		died.emit()

# When vehicle crashes
func onCrash(score : int):
	addScore(score)
	var shakeStrength : float = tanh(score) * 3 # Should generate a shake score from 0 to 3
	cameraShaker.shakeCamera(shakeStrength, 1.5)


func addScore(number : int):
	addAndUpdateScore.emit(number)

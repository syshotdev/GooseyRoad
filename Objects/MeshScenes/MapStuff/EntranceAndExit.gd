extends Node3D

# Class for making tunnel entrances and exits

@export var tunnelExit : Node3D
@export var tunnelEntrance : Node3D

func _ready():
	tunnelExit.position.x = (-Constants.blockSize * Constants.widthOfMap / 2) + 1 # Position to the left
	tunnelEntrance.position.x = (Constants.blockSize * Constants.widthOfMap / 2) - 1 # Position to the right

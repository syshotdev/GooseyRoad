extends Control

@export var scoreLabel : Label
@export var instructionText : Control

func _ready():
	scoreLabel.visible = false
	instructionText.visible = true

func setScore(score : int):
	scoreLabel.text = "Score: " + str(score)


func startGame():
	scoreLabel.visible = true
	instructionText.visible = false

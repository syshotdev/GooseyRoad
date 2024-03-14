extends Control

@export var scoreLabel : Label
@export var instructionLabel : Control
@export var diedLabel : Label

func _ready():
	scoreLabel.visible = false
	instructionLabel.visible = true
	diedLabel.visible = false


func setScore(score : int):
	scoreLabel.text = "Score: " + str(score)


func startGame():
	scoreLabel.visible = true
	instructionLabel.visible = false
	diedLabel.visible = false


func died():
	diedLabel.visible = true

extends Control

@export var mainScene : PackedScene
@export var UIScene : PackedScene
var main : Node3D = null
var UI : Control = null
var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	resetGame()


func _input(event):
	if event is InputEventKey:
		startGame()


# Restarts all the variables, and the lazy way is just turn off and on again
func resetGame():
	for child in get_children():
		child.queue_free() # Remove all the children
	
	main = mainScene.instantiate()
	add_child(main)
	UI = UIScene.instantiate()
	add_child(UI)
	main.died.connect(died)
	main.addAndUpdateScore.connect(addScore)
	
	score = 0
	
	pauseGame()


func startGame():
	UI.startGame()
	main.set_process(true)

# When goose dies
func died():
	UI.died()
	pauseGame()
	var timer := get_tree().create_timer(2)
	timer.timeout.connect(resetGame)


func pauseGame():
	main.set_process(false)

# Add score and update it
func addScore(number : int):
	setScore(number + score)


func setScore(number : int):
	score = number
	UI.setScore(number)

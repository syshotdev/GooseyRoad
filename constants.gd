extends Node

class_name Constants

const cameraSpeed := 1.0 # Meters per second
const defaultCameraShakeStrength := 1.0
const defaultCameraShakeDecay := 1.0
const defaultCameraShakeSpeed := 60.0
const carSpeed := 10.0 # Meters per second
const brakingPower := 5 # Controls how fast velocity in car goes to 0, velocity % goes down compoundingly by that much per second.
const trainSpeed := 50.0
# Note: move_and_slide() also makes it slow down.

const carCrashScore := 50
const trainCrashScore := 15

const blockSize := 1.0 # Meters
const widthOfMap := blockSize * 20.0 # Width of map in block chunks

const mapAmountOfStrips := 30 # Length of map (in strips)
const mapStripsBehindPlayer := 7 # How many strips are behind the player
const mapStripsInFrontPlayer := mapAmountOfStrips - mapStripsBehindPlayer

const treesPerForest := widthOfMap / 4
const minNumberOfTrainCarts := 1
const maxNumberOfTrainCarts := 5

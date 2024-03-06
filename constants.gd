extends Node

class_name Constants

const cameraSpeed := 1 # Meters per second
const carSpeed := 10.0 # Meters per second

const blockSize := 1.0 # Meters

const widthOfMap := blockSize * 20.0 # Width of map in block chunks
const mapAmountOfStrips := 20 # Length of map (in strips)
const mapStripsBehindPlayer := 7 # How many strips are behind the player
const mapStripsInFrontPlayer := mapAmountOfStrips - mapStripsBehindPlayer

const forwardDirection : Vector3 = Vector3.FORWARD

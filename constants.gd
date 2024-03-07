extends Node

class_name Constants

const carSpeed := 10.0 # Meters per second

const blockSize := 1.0 # Meters
const widthOfMap := blockSize * 20.0 # Width of map in block chunks
<<<<<<< HEAD
const mapAmountOfStrips := 10 # Length of map (in strips)
const mapStripsBehindPlayer := 5 # How many strips are behind the player
=======
const mapAmountOfStrips := 20 # Length of map (in strips)
const mapStripsBehindPlayer := 7 # How many strips are behind the player
>>>>>>> parent of 488ca77 (Made player collide with things, it's bad.)
const mapStripsInFrontPlayer := mapAmountOfStrips - mapStripsBehindPlayer

const forwardDirection : Vector3 = Vector3.FORWARD

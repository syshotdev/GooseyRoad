extends Node3D

class_name CameraShake

# This script for shaking camera

@export var camera : Camera3D
@onready var noise := FastNoiseLite.new()
var shakeStrength : float = 0
var shakeDecayRate : float = 1
var noiseIndex : float = 0 # Goes up every screen shake for different screen shake

func _ready():
	noise.seed = randi()


func _process(delta):
	shakeStrength = lerp(shakeStrength, 0.0, delta * shakeDecayRate)
	camera.h_offset = lerp(camera.h_offset, getRandomOffset(delta).x, 0.5)
	camera.v_offset = lerp(camera.v_offset, getRandomOffset(delta).y, 0.5)


func shakeCamera(newShakeStrength : float, newShakeDecayRate : float):
	self.shakeStrength = newShakeStrength
	self.shakeDecayRate = newShakeDecayRate
	var randomVarNOUse


func getRandomOffset(delta : float) -> Vector2:
	noiseIndex += Constants.defaultCameraShakeSpeed * delta
	return Vector2(
		noise.get_noise_2d(1, noiseIndex) * shakeStrength, 
		noise.get_noise_2d(100, noiseIndex) * shakeStrength)

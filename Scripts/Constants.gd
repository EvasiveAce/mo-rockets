extends Control


export(float) var defaultFuel = 5.0
export(float) var defaultSpeed = 2.5
export(float) var defaultWeight = -2.5

var tutorial = true

var stage = ""

var stats = ["Fuel", "Speed"]

var rocketNose
var rocketNoseModulate

var rocketBody
var rocketBodyModulate

var rocketBottom
var rocketBottomModulate

var fuel = 0.0
var speed = 0.0
var weight = 0.0

var highestAltitude = 1000.0
var altitude = 0.0



func _determineTrait(trait, value):
	if trait == "Speed":
		speed += value
	elif trait == "Weight":
		weight += value
	elif trait == "Fuel":
		fuel += value
